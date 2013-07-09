package com.serotonin.m2m2.rt.maint.work;

import java.io.BufferedWriter;
import java.io.File;
import java.io.FileWriter;
import java.io.FilenameFilter;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Arrays;
import java.util.Date;
import java.util.LinkedHashMap;
import java.util.Map;

import org.apache.commons.io.comparator.LastModifiedFileComparator;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.joda.time.DateTime;

import com.serotonin.ShouldNeverHappenException;
import com.serotonin.m2m2.Common;
import com.serotonin.m2m2.db.dao.DataPointDao;
import com.serotonin.m2m2.db.dao.DataSourceDao;
import com.serotonin.m2m2.db.dao.EventDao;
import com.serotonin.m2m2.db.dao.MailingListDao;
import com.serotonin.m2m2.db.dao.PublisherDao;
import com.serotonin.m2m2.db.dao.SystemSettingsDao;
import com.serotonin.m2m2.db.dao.UserDao;
import com.serotonin.m2m2.i18n.TranslatableMessage;
import com.serotonin.m2m2.module.EmportDefinition;
import com.serotonin.m2m2.module.ModuleRegistry;
import com.serotonin.m2m2.rt.event.type.SystemEventType;
import com.serotonin.m2m2.util.DateUtils;
import com.serotonin.m2m2.web.dwr.EmportDwr;
import com.serotonin.timer.CronTimerTrigger;
import com.serotonin.timer.TimerTask;

public class BackupWorkItem implements WorkItem {
    private static final Log LOG = LogFactory.getLog(BackupWorkItem.class);
    public static final String BACKUP_DATE_FORMAT = "MM-dd-yyyy_HHmmss"; //Used to for filename and property value for last run
    public static final SimpleDateFormat dateFormatter = new SimpleDateFormat(BACKUP_DATE_FORMAT);
    
    private static BackupSettingsTask task; //Static holder to re-schedule task if necessary
    /**
     * Statically Schedule this task when the app starts up.
     * 
     * TODO Make this an RTM and add to the RuntimeManager's list of startup RTMS
     * currently only the Module RTMs get started there.
     */
    public static void schedule() {
        try {
            // Test trigger for running every 25 seconds.
            //String cronTrigger = "0/25 * * * * ?";
            // Trigger to run at Set Hour/Minute "s m h * * ?";
    		int hour = SystemSettingsDao.getIntValue(SystemSettingsDao.BACKUP_HOUR);
    		int minute = SystemSettingsDao.getIntValue(SystemSettingsDao.BACKUP_MINUTE);
    		
    		String cronTrigger = "0 " + minute + " " + hour + " * * ?"; 
    		task = new BackupSettingsTask(cronTrigger);
            Common.timer.schedule(task);
        }
        catch (ParseException e) {
            throw new ShouldNeverHappenException(e);
        }
    }
    
    /**
     * Safely unschedule the task if it exists
     */
    public static void unschedule(){
    	if(task != null){
    		task.cancel();
    	}
    }
    
    
    
	@Override
	public int getPriority() {
		return WorkItem.PRIORITY_MEDIUM;
	}

	public static void queueBackup(String backupLocation){
		
		BackupWorkItem item = new BackupWorkItem();
		item.backupLocation = backupLocation;
		
		Common.backgroundProcessing.addWorkItem(item);
		
	}
	
    
    private String backupLocation;
    
	@Override
	public void execute() {
		LOG.info("Starting backup WorkItem.");
		//Create the filename
		
		String runtimeString = dateFormatter.format(new Date());
		String filename = "backup-";
		filename += runtimeString;
		filename += ".json";
		
		//Fill the full path
		String fullFilePath = this.backupLocation;
		if(fullFilePath.endsWith("/")){
			fullFilePath += filename;
		}else{
			fullFilePath += "/";
			fullFilePath += filename;
		}
		
		//Collect the json backup data
		String jsonData = getBackup();
		
		//Write to file
		try{
			File file = new File(fullFilePath);
			if(!file.exists())
				if(!file.createNewFile()){
					LOG.warn("Unable to create backup file: " + fullFilePath);
		            SystemEventType.raiseEvent(new SystemEventType(SystemEventType.TYPE_BACKUP_FAILURE),
		                    System.currentTimeMillis(), false,
		                    new TranslatableMessage("event.backup.failure", fullFilePath, "Unable to create backup file"));

					return;
				}
			FileWriter fw = new FileWriter(file);
			BufferedWriter bw = new BufferedWriter(fw);
			bw.write(jsonData);
			bw.close();
			//Store the last successful backup time
			SystemSettingsDao dao = new SystemSettingsDao();
			dao.setValue(SystemSettingsDao.BACKUP_LAST_RUN_SUCCESS,runtimeString);
			
			//Clean up old files, keeping the correct number as the history
			int maxFiles = SystemSettingsDao.getIntValue(SystemSettingsDao.BACKUP_FILE_COUNT);
			File backupDir = new File(this.backupLocation);
			File[] files = backupDir.listFiles(new FilenameFilter(){
				public boolean accept(File dir, String name){
					return name.toLowerCase().endsWith(".json");
				}
			});
			//Sort the files by date
	        Arrays.sort(files, LastModifiedFileComparator.LASTMODIFIED_REVERSE);
	        
	        //Keep the desired history
	        for(int i=maxFiles; i<files.length; i++){
	        	try{
	        		files[i].delete(); //Remove it
	        	}catch(Exception e){
	        		LOG.warn("Unable to delete file: " + files[i].getAbsolutePath(),e);
	        	}
	        }
	        
		}catch(Exception e){
			LOG.warn(e);
            SystemEventType.raiseEvent(new SystemEventType(SystemEventType.TYPE_BACKUP_FAILURE),
                    System.currentTimeMillis(), false,
                    new TranslatableMessage("event.backup.failure", fullFilePath, e.getMessage()));
		}
		
	}

	public String getBackup(){
        Map<String, Object> data = new LinkedHashMap<String, Object>();

        data.put(EmportDwr.DATA_SOURCES, new DataSourceDao().getDataSources());
        data.put(EmportDwr.DATA_POINTS, new DataPointDao().getDataPoints(null, true));
        data.put(EmportDwr.USERS, new UserDao().getUsers());
        data.put(EmportDwr.MAILING_LISTS, new MailingListDao().getMailingLists());
        data.put(EmportDwr.PUBLISHERS, new PublisherDao().getPublishers());
        data.put(EmportDwr.EVENT_HANDLERS, new EventDao().getEventHandlers());
        data.put(EmportDwr.POINT_HIERARCHY, new DataPointDao().getPointHierarchy(true).getRoot().getSubfolders());

        //Export all module data too
        for (EmportDefinition def : ModuleRegistry.getDefinitions(EmportDefinition.class)) {
                data.put(def.getElementId(), def.getExportData());
        }

        return EmportDwr.export(data);
	}

	
    static class BackupSettingsTask extends TimerTask {
    	BackupSettingsTask(String cronTrigger) throws ParseException {
            super(new CronTimerTrigger(cronTrigger));
        }

        @Override
        public void run(long runtime) {

        	//Should we run the backup?
        	try{
        		String lastRunDateString = SystemSettingsDao.getValue(SystemSettingsDao.BACKUP_LAST_RUN_SUCCESS);
	        	String backupLocation = SystemSettingsDao.getValue(SystemSettingsDao.BACKUP_FILE_LOCATION);

	        	//Have we ever run?
	        	if(lastRunDateString != null){
	        		Date lastRunDate = dateFormatter.parse(lastRunDateString);
	        		DateTime lastRun = new DateTime(lastRunDate);
	        		//Compute the next run time off of the last run time
		            DateTime nextRun = DateUtils.plus(lastRun, SystemSettingsDao.getIntValue(SystemSettingsDao.BACKUP_PERIOD_TYPE),
		                    SystemSettingsDao.getIntValue(SystemSettingsDao.BACKUP_PERIODS));
		        	//Is the next run time now or before now?
		            if(!nextRun.isAfter(runtime)){
			        	BackupWorkItem.queueBackup(backupLocation);
		            }

	        	}else{
		        	BackupWorkItem.queueBackup(backupLocation);
	        	}
	       
	        	
        	}catch(Exception e){
        		LOG.error(e);
	            SystemEventType.raiseEvent(new SystemEventType(SystemEventType.TYPE_BACKUP_FAILURE),
	                    System.currentTimeMillis(), false,
	                    new TranslatableMessage("event.backup.failure", "no file", e.getMessage()));

        	}
        }
    }
	
}
