//
//  Preferences.swift
//  iSaveMoney
//
//  Created by Armel Koudoum on 6/30/16.
//  Copyright © 2016 UlmatCorpit. All rights reserved.
//

//import RealmSwift

import Firebase
import FirebaseDatabase

public class Preferences{
    public var gid:String!
    
    
    /*@objc dynamic var guid = ""
    @objc dynamic var name = ""
    @objc dynamic var value = ""
    @objc dynamic var type = 0
    @objc dynamic var token = ""
    @objc dynamic var created = Date(timeIntervalSince1970: 1)
    @objc dynamic var updated = Date(timeIntervalSince1970: 1)*/
    
    @objc dynamic var  selectedMonthlyBudget:String! //SELECTED_MONTHLY_BUDGET
    var  isFirstTime:Bool! //IS_FIRST_TIME
    @objc public dynamic var  dateFormat:String! //PREF_DATE_FORMAT
    @objc public dynamic var  timeFormat:String! //PREF_TIME_FORMAT
    var  settingDone:Bool! //PREF_SETTING_DONE
    @objc dynamic var currency:String! //USER_CURRENCY
     var hasPaidUnlimited:Bool! //HAS_PAID_UNLIMITED
    var numberOfUse:Int! //NUMBER_OF_USE
    var numberOfExpenses:Int! //NUMBER_OF_EXPENSES
    var numberOfIncomes:Int! //NUMBER_OF_INCOMES
    
    
    
    var isStatisticsOpened:Bool! //PREF_STATISTIC_OPENED
    var userLearnedCreateCategory:Bool! //PREF_USER_LEARNED_CREATE_CATEGORY
    var userLearnedShare:Bool! //PREF_USER_LEARNED_SHARE
    var userLearnedSwipeDelete:Bool! //PREF_USER_LEARNED_SWIPE_DELETE
    var prefAskedFeedback:Bool! //PREF_ASKED_FEEDBACK
    var prefAskedFeedbackLater:Int! //PREF_ASKED_FEEDBACK_LATER
    var prefAskedShare:Bool! //PREF_ASKED_SHARE
    
    var prefAskedShareLater:Int! //PREF_ASKED_SHARE_LATER
    @objc dynamic var prefLicence:String! //PREF_LICENCE
    var prefLicenceChecked:Bool! //PREF_LICENCE_CHECKED
    var prefThemeChoose:Int! //PREF_THEME_CHOOSE
    var prefCampaignBackup:Bool! //PREF_CAMPAIGN_BACKUP
    var prefPinCode:String! //PREF_PIN_CODE
    var prefLoggedIn:Bool! //PREF_LOGGED_IN
    var prefHelpCategory:Bool! //PREF_HELP_CATEGORY
    var prefHelpExpense:Bool! //PREF_HELP_EXPENSE
    var prefHelpIncome:Bool! //PREF_HELP_INCOME
    var prefWidgetShowIncome:Bool! //PREF_WIDGET_SHOW_INCOME
    var prefWidgetShowExpense:Bool! //PREF_WIDGET_SHOW_EXPENSE
    var prefCheckLicenceTime:Int! //PREF_CHECK_LICENCE_TIME
    var prefNotifiedForWidget:Bool! //PREF_NOTIFIED_FOR_WIDGET
    var prefNotifiedForTour:Bool! //PREF_NOTIFIED_TOUR
    var prefEncoding:String! //PREF_ENCODING
    var prefRemindMissingBudget:Bool! //PREF_REMIND_MISSING_BUDGET
    @objc public dynamic var prefUserIdentifier:String! //PREF_USER_IDENTIFIER
    @objc public dynamic var prefUserEmail:String! //PREF_USER_EMAIL
    var prefLearnedSwipeCategory:Bool! //PREF_LEARNED_SWIPE_CATEGORY
    var prefLearnedSwipeExpense:Bool! //PREF_LEARNED_SWIPE_EXPENSE
    var prefLearnedSwipeIncome:Bool! //PREF_LEARNED_SWIPE_INCOME
    var prefLearnedSwipeAccount:Bool! //PREF_LEARNED_SWIPE_ACCOUNT
    var prefLearnedSwipePayee:Bool! //PREF_LEARNED_SWIPE_PAYEE
    var prefLearnedSwipePayer:Bool! //PREF_LEARNED_SWIPE_PAYER
    var prefLearnedSwipeBudget:Bool! //PREF_LEARNED_SWIPE_BUDGET
    var prefLearnedSwipeSchedule:Bool! //PREF_LEARNED_SWIPE_SCHEDULE
    var prefTurnOnReminder:Bool! //PREF_TURN_ON_REMINDER
    var prefTurnOnNotifications:Bool! //PREF_TURN_ON_NOTIFICATIONS
    var prefNewReminderScheduler:Bool! //PREF_NEW_REMINDER_SETTINGS
    var prefCancelNextReminder:Bool! //PREF_CANCEL_NEXT_REMINDER
    var prefLastReminderDateTime:Int! //PREF_LAST_REMINDER_DATE_TIME
    var prefLastSchedulerRun:Int! //PREF_LAST_SCHEDULER_RUN
    var prefDrawerActivities:Bool! //PREF_DRAWER_ACTIVITIES
    var prefDrawerAccounts:Bool! //PREF_DRAWER_ACCOUNTS
    var prefDrawerHelp:Bool! //PREF_DRAWER_HELP
    var prefCreatedAccount:Bool! //PREF_CREATED_ACCOUNT
    var prefNeverSignIn:Bool! //PREF_CREATED_ACCOUNT
    @objc dynamic var prefToken:String! //PREF_CREATED_ACCOUNT
    var prefSubscriptionActive:Bool! //PREF_SUBSCRIPTION_ACTIVE
    var prefSubscriptionDue:Int! //PREF_SUBSCRIPTION_DUE
    var selectedLanguage:String!
    
    public init(){}
    
    public init(snapshot: DataSnapshot!) {
        
        let value = snapshot.value as? NSDictionary
        
        self.gid = snapshot.key
        self.gid = value?["gid"] as? String ?? ""
        
        
        self.selectedMonthlyBudget = value?["selectedMonthlyBudget"] as? String ?? ""
        self.isFirstTime = value?["isFirstTime"] as? Bool ?? true
        self.dateFormat = value?["dateFormat"] as? String ?? ""
        self.timeFormat = value?["timeFormat"] as? String ?? ""
        self.settingDone = value?["settingDone"] as? Bool ?? false
        self.currency = value?["currency"] as? String ?? ""
        self.hasPaidUnlimited = value?["hasPaidUnlimited"] as? Bool ?? false
        self.numberOfUse = value?["numberOfUse"] as? Int ?? 0
        self.numberOfExpenses = value?["numberOfExpenses"] as? Int ?? 0
        self.numberOfIncomes = value?["numberOfIncomes"] as? Int ?? 0
        self.isStatisticsOpened = value?["isStatisticsOpened"] as? Bool ?? true
        self.userLearnedCreateCategory = value?["userLearnedCreateCategory"] as? Bool ?? false
        self.userLearnedShare = value?["userLearnedShare"] as? Bool ?? false
        self.userLearnedSwipeDelete = value?["userLearnedSwipeDelete"] as? Bool ?? false
        self.prefAskedFeedback = value?["prefAskedFeedback"] as? Bool ?? false
        self.prefAskedFeedbackLater = value?["prefAskedFeedbackLater"] as? Int ?? 1
        self.prefAskedShare = value?["prefAskedShare"] as? Bool ?? false
        self.prefAskedShareLater = value?["prefAskedShareLater"] as? Int ?? 0
        self.prefLicence = value?["prefLicence"] as? String ?? ""
        self.prefLicenceChecked = value?["prefLicenceChecked"] as? Bool ?? false
        self.prefThemeChoose = value?["prefThemeChoose"] as? Int ?? 1
        self.prefCampaignBackup = value?["prefCampaignBackup"] as? Bool ?? false
        self.prefPinCode = value?["prefPinCode"] as? String ?? ""
        self.prefLoggedIn = value?["prefLoggedIn"] as? Bool ?? false
        self.prefHelpCategory = value?["prefHelpCategory"] as? Bool ?? false
        self.prefHelpExpense = value?["prefHelpExpense"] as? Bool ?? false
        self.prefHelpIncome = value?["prefHelpIncome"] as? Bool ?? false
        self.prefWidgetShowIncome = value?["prefWidgetShowIncome"] as? Bool ?? false
        self.prefWidgetShowExpense = value?["prefWidgetShowExpense"] as? Bool ?? false
        self.prefCheckLicenceTime = value?["prefCheckLicenceTime"] as? Int ?? 0
        self.prefNotifiedForWidget = value?["prefNotifiedForWidget"] as? Bool ?? false
        self.prefNotifiedForTour = value?["prefNotifiedForTour"] as? Bool ?? false
        self.prefEncoding = value?["prefEncoding"] as? String ?? ""
        self.prefRemindMissingBudget = value?["prefRemindMissingBudget"] as? Bool ?? false
        self.prefUserIdentifier = value?["prefUserIdentifier"] as? String ?? ""
        self.prefUserEmail = value?["prefUserEmail"] as? String ?? ""
        self.prefLearnedSwipeCategory = value?["prefLearnedSwipeCategory"] as? Bool ?? false
        self.prefLearnedSwipeExpense = value?["prefLearnedSwipeExpense"] as? Bool ?? false
        self.prefLearnedSwipeIncome = value?["prefLearnedSwipeIncome"] as? Bool ?? false
        self.prefLearnedSwipeAccount = value?["prefLearnedSwipeAccount"] as? Bool ?? false
        self.prefLearnedSwipePayee = value?["prefLearnedSwipePayee"] as? Bool ?? false
        self.prefLearnedSwipePayer = value?["prefLearnedSwipePayer"] as? Bool ?? false
        self.prefLearnedSwipeBudget = value?["prefLearnedSwipeBudget"] as? Bool ?? false
        self.prefLearnedSwipeSchedule = value?["prefLearnedSwipeSchedule"] as? Bool ?? false
        self.prefTurnOnReminder = value?["prefTurnOnReminder"] as? Bool ?? false
        self.prefTurnOnNotifications = value?["prefTurnOnNotifications"] as? Bool ?? false
        self.prefNewReminderScheduler = value?["prefNewReminderScheduler"] as? Bool ?? false
        self.prefCancelNextReminder = value?["prefCancelNextReminder"] as? Bool ?? false
        self.prefLastReminderDateTime = value?["prefLastReminderDateTime"] as? Int ?? Int(Date().timeIntervalSince1970)
        self.prefLastSchedulerRun = value?["prefLastSchedulerRun"] as? Int ?? Int(Date().timeIntervalSince1970)
        self.prefDrawerActivities = value?["prefDrawerActivities"] as? Bool ?? false
        self.prefDrawerAccounts = value?["prefDrawerAccounts"] as? Bool ?? false
        self.prefDrawerHelp = value?["prefDrawerHelp"] as? Bool ?? true
        self.prefCreatedAccount = value?["prefCreatedAccount"] as? Bool ?? true
        self.prefNeverSignIn = value?["prefNeverSignIn"] as? Bool ?? true
        self.prefToken = value?["prefToken"] as? String ?? ""
        self.prefSubscriptionActive = value?["prefSubscriptionActive"] as? Bool ?? false
        self.prefSubscriptionDue = value?["prefSubscriptionDue"] as? Int ?? 1
        self.selectedLanguage = value?["selectedLanguage"] as? String ?? ""
        
        
    }
    
    public init(value:[String:Any]) {
        
        self.gid = value["gid"] as? String ?? ""
        
        
        self.selectedMonthlyBudget = value["selectedMonthlyBudget"] as? String ?? ""
        self.isFirstTime = value["isFirstTime"] as? Bool ?? true
        self.dateFormat = value["dateFormat"] as? String ?? ""
        self.timeFormat = value["timeFormat"] as? String ?? ""
        self.settingDone = value["settingDone"] as? Bool ?? false
        self.currency = value["currency"] as? String ?? ""
        self.hasPaidUnlimited = value["hasPaidUnlimited"] as? Bool ?? false
        self.numberOfUse = value["numberOfUse"] as? Int ?? 0
        self.numberOfExpenses = value["numberOfExpenses"] as? Int ?? 0
        self.numberOfIncomes = value["numberOfIncomes"] as? Int ?? 0
        self.isStatisticsOpened = value["isStatisticsOpened"] as? Bool ?? true
        self.userLearnedCreateCategory = value["userLearnedCreateCategory"] as? Bool ?? false
        self.userLearnedShare = value["userLearnedShare"] as? Bool ?? false
        self.userLearnedSwipeDelete = value["userLearnedSwipeDelete"] as? Bool ?? false
        self.prefAskedFeedback = value["prefAskedFeedback"] as? Bool ?? false
        self.prefAskedFeedbackLater = value["prefAskedFeedbackLater"] as? Int ?? 1
        self.prefAskedShare = value["prefAskedShare"] as? Bool ?? false
        self.prefAskedShareLater = value["prefAskedShareLater"] as? Int ?? 0
        self.prefLicence = value["prefLicence"] as? String ?? ""
        self.prefLicenceChecked = value["prefLicenceChecked"] as? Bool ?? false
        self.prefThemeChoose = value["prefThemeChoose"] as? Int ?? 1
        self.prefCampaignBackup = value["prefCampaignBackup"] as? Bool ?? false
        self.prefPinCode = value["prefPinCode"] as? String ?? ""
        self.prefLoggedIn = value["prefLoggedIn"] as? Bool ?? false
        self.prefHelpCategory = value["prefHelpCategory"] as? Bool ?? false
        self.prefHelpExpense = value["prefHelpExpense"] as? Bool ?? false
        self.prefHelpIncome = value["prefHelpIncome"] as? Bool ?? false
        self.prefWidgetShowIncome = value["prefWidgetShowIncome"] as? Bool ?? false
        self.prefWidgetShowExpense = value["prefWidgetShowExpense"] as? Bool ?? false
        self.prefCheckLicenceTime = value["prefCheckLicenceTime"] as? Int ?? 0
        self.prefNotifiedForWidget = value["prefNotifiedForWidget"] as? Bool ?? false
        self.prefNotifiedForTour = value["prefNotifiedForTour"] as? Bool ?? false
        self.prefEncoding = value["prefEncoding"] as? String ?? ""
        self.prefRemindMissingBudget = value["prefRemindMissingBudget"] as? Bool ?? false
        self.prefUserIdentifier = value["prefUserIdentifier"] as? String ?? ""
        self.prefUserEmail = value["prefUserEmail"] as? String ?? ""
        self.prefLearnedSwipeCategory = value["prefLearnedSwipeCategory"] as? Bool ?? false
        self.prefLearnedSwipeExpense = value["prefLearnedSwipeExpense"] as? Bool ?? false
        self.prefLearnedSwipeIncome = value["prefLearnedSwipeIncome"] as? Bool ?? false
        self.prefLearnedSwipeAccount = value["prefLearnedSwipeAccount"] as? Bool ?? false
        self.prefLearnedSwipePayee = value["prefLearnedSwipePayee"] as? Bool ?? false
        self.prefLearnedSwipePayer = value["prefLearnedSwipePayer"] as? Bool ?? false
        self.prefLearnedSwipeBudget = value["prefLearnedSwipeBudget"] as? Bool ?? false
        self.prefLearnedSwipeSchedule = value["prefLearnedSwipeSchedule"] as? Bool ?? false
        self.prefTurnOnReminder = value["prefTurnOnReminder"] as? Bool ?? false
        self.prefTurnOnNotifications = value["prefTurnOnNotifications"] as? Bool ?? false
        self.prefNewReminderScheduler = value["prefNewReminderScheduler"] as? Bool ?? false
        self.prefCancelNextReminder = value["prefCancelNextReminder"] as? Bool ?? false
        self.prefLastReminderDateTime = value["prefLastReminderDateTime"] as? Int ?? Int(Date().timeIntervalSince1970)
        self.prefLastSchedulerRun = value["prefLastSchedulerRun"] as? Int ?? Int(Date().timeIntervalSince1970)
        self.prefDrawerActivities = value["prefDrawerActivities"] as? Bool ?? false
        self.prefDrawerAccounts = value["prefDrawerAccounts"] as? Bool ?? false
        self.prefDrawerHelp = value["prefDrawerHelp"] as? Bool ?? true
        self.prefCreatedAccount = value["prefCreatedAccount"] as? Bool ?? true
        self.prefNeverSignIn = value["prefNeverSignIn"] as? Bool ?? true
        self.prefToken = value["prefToken"] as? String ?? ""
        self.prefSubscriptionActive = value["prefSubscriptionActive"] as? Bool ?? false
        self.prefSubscriptionDue = value["prefSubscriptionDue"] as? Int ?? 1
        self.selectedLanguage = value["selectedLanguage"] as? String ?? ""
    }
    
   public func readValuesFromPreferences(myPreferences:MyPreferences) {
    
        do {
            self.selectedMonthlyBudget = myPreferences.getCurrentId();
            self.isFirstTime = myPreferences.isFirstTime();
            self.dateFormat = myPreferences.getDateFormat();
            self.timeFormat = myPreferences.getTimeFormat();
            self.settingDone = myPreferences.isSettingDone();
            self.currency = myPreferences.getCurrency();
            self.hasPaidUnlimited = myPreferences.getPaidUnlimited();
            self.numberOfUse = myPreferences.getAppUsage();
            self.numberOfExpenses = myPreferences.getExpenseUsage();
            self.numberOfIncomes = myPreferences.getIncomeUsage();
        
            self.isStatisticsOpened = myPreferences.isStatOpened();//PREF_STATISTIC_OPENED
            self.userLearnedCreateCategory = myPreferences.didLearnedAddCategory();//PREF_USER_LEARNED_CREATE_CATEGORY
            self.userLearnedShare = myPreferences.didLearnedShare();//PREF_USER_LEARNED_SHARE
            self.userLearnedSwipeDelete = myPreferences.didLearnedWipe();//PREF_USER_LEARNED_SWIPE_DELETE
            self.prefAskedFeedback = myPreferences.getPrefAskedFeedback();//PREF_ASKED_FEEDBACK
            self.prefAskedFeedbackLater = myPreferences.getPrefAskedFeedbackLaster();//PREF_ASKED_FEEDBACK_LATER
            self.prefAskedShare = myPreferences.getPrefAskedShare();//PREF_ASKED_SHARE
        
            self.prefAskedShareLater = myPreferences.getPrefAskedShareLater(); //PREF_ASKED_SHARE_LATER
            self.prefLicence = myPreferences.getLicence(); //PREF_LICENCE
            self.prefLicenceChecked = myPreferences.getIsLicence(); //PREF_LICENCE_CHECKED
            self.prefThemeChoose = myPreferences.getChooseTheme(); //PREF_THEME_CHOOSE
            self.prefCampaignBackup = myPreferences.getCampaignBackup(); //PREF_CAMPAIGN_BACKUP
            self.prefPinCode = myPreferences.getPINCode(); //PREF_PIN_CODE
            self.prefLoggedIn = myPreferences.isLoggedIn(); //PREF_LOGGED_IN
            self.prefHelpCategory = myPreferences.helpCategory(); //PREF_HELP_CATEGORY
            self.prefHelpExpense = myPreferences.helpExpense(); //PREF_HELP_EXPENSE
            self.prefHelpIncome = myPreferences.helpCIncome(); //PREF_HELP_INCOME
            self.prefWidgetShowIncome = myPreferences.showWidgetIncome(); //PREF_WIDGET_SHOW_INCOME
            self.prefWidgetShowExpense = myPreferences.showWidgetExpense(); //PREF_WIDGET_SHOW_EXPENSE
            self.prefCheckLicenceTime = myPreferences.getCheckLicence(); //PREF_LICENCE_CHECKED
            self.prefNotifiedForWidget = myPreferences.isNotifiedForWidget(); //PREF_NOTIFIED_FOR_WIDGET
            self.prefNotifiedForTour = myPreferences.isNotifiedForTour(); //PREF_NOTIFIED_TOUR
            self.prefEncoding = myPreferences.getEncoding(); //PREF_ENCODING
            self.prefRemindMissingBudget = myPreferences.canRemindMissingBudget(); //PREF_REMIND_MISSING_BUDGET
            self.prefUserIdentifier = myPreferences.getUserIdentifier(); //PREF_USER_IDENTIFIER
            self.prefUserEmail = myPreferences.getUserEmail(); //PREF_USER_EMAIL
            self.prefLearnedSwipeCategory = myPreferences.didLearnedWipeCategory(); //PREF_LEARNED_SWIPE_CATEGORY
            self.prefLearnedSwipeExpense = myPreferences.didLearnedWipeCategory(); //PREF_LEARNED_SWIPE_EXPENSE
            self.prefLearnedSwipeIncome = myPreferences.didLearnedWipeIncome(); //PREF_LEARNED_SWIPE_INCOME
            self.prefLearnedSwipeAccount = myPreferences.didLearnedWipeAccount(); //PREF_LEARNED_SWIPE_ACCOUNT
            self.prefLearnedSwipePayee = myPreferences.didLearnedWipePayee(); //PREF_LEARNED_SWIPE_PAYEE
            self.prefLearnedSwipePayer = myPreferences.didLearnedWipePayer(); //PREF_LEARNED_SWIPE_PAYER
            self.prefLearnedSwipeBudget = myPreferences.didLearnedWipeBudget(); //PREF_LEARNED_SWIPE_BUDGET
            self.prefLearnedSwipeSchedule = myPreferences.didLearnedWipeSchedule(); //PREF_LEARNED_SWIPE_SCHEDULE
            self.prefTurnOnReminder = myPreferences.isReminderOn(); //PREF_TURN_ON_REMINDER
            self.prefTurnOnNotifications = myPreferences.isNotificationsOn(); //PREF_TURN_ON_NOTIFICATIONS
            self.prefNewReminderScheduler = myPreferences.didResetNewReminder(); //PREF_NEW_REMINDER_SETTINGS
            self.prefCancelNextReminder = myPreferences.didCancelNextReminder(); //PREF_CANCEL_NEXT_REMINDER
            self.prefLastReminderDateTime = myPreferences.getLastReminder(); //PREF_LAST_REMINDER_DATE_TIME
            self.prefLastSchedulerRun = myPreferences.getLastSchedulerRun(); //PREF_LAST_SCHEDULER_RUN
            self.prefDrawerActivities = myPreferences.getDrawerActivities(); //PREF_DRAWER_ACTIVITIES
            self.prefDrawerAccounts = myPreferences.getDrawerAccount(); //PREF_DRAWER_ACCOUNTS
            self.prefDrawerHelp = myPreferences.getDrawerHelp(); //PREF_DRAWER_HELP
            self.prefCreatedAccount = myPreferences.getCreatedAccount(); //PREF_CREATED_ACCOUNTself.
            self.prefNeverSignIn = myPreferences.isNeverSignIn(); //PREF_CREATED_ACCOUNTself.
            self.prefToken = myPreferences.getToken(); //PREF_CREATED_ACCOUNTself.
            self.prefSubscriptionActive = myPreferences.getIsSubscriptionActive(); //PREF_CREATED_ACCOUNTthis.
            self.prefSubscriptionDue = myPreferences.getSubscriptionDueDate(); //PREF_CREATED_ACCOUNTthis.
            self.selectedLanguage = myPreferences.getSelectedLanguage()
        } catch {
            
            //Crashlytics.sharedInstance().recordError(error)
        }
    }
    
    public func saveValuesToPreferences(prefs:[String:Any]) {
    
        let mMyPreferences:MyPreferences = MyPreferences()
        
        if (prefs["selectedMonthlyBudget"] != nil) {
            
            mMyPreferences.setSelectedBudget(budget_did: prefs["selectedMonthlyBudget"] as! String)
        }
    
       
        if (prefs["isFirstTime"] != nil) {
            mMyPreferences.setIsFirstTime(val: prefs["isFirstTime"] as! Bool)
        }
   
    
        if (prefs["dateFormat"] != nil) {
            mMyPreferences.setDateFormat(prefs["dateFormat"] as! String)
        }
    
    
        if (prefs["timeFormat"] != nil) {
            mMyPreferences.setTimeFormat(prefs["timeFormat"] as! String)
        }
    
    
        if (prefs["settingDone"] != nil) {
            mMyPreferences.setSettingDone(val: prefs["settingDone"] as! Bool)
        }
    
    
        if (prefs["currency"] != nil) {
            mMyPreferences.setCurrency(prefs["currency"] as! String)
        }
    
    
        if (prefs["hasPaidUnlimited"] != nil) {
            mMyPreferences.setPaidUnlimited(val: prefs["hasPaidUnlimited"] as! Bool)
        }
    
    
        if (prefs["numberOfUse"] != nil) {
            mMyPreferences.setAppUsage(usage: prefs["numberOfUse"] as! Int)
        }
    
    
        if (prefs["numberOfExpenses"] != nil) {
            mMyPreferences.setExpenseUsage(usage: prefs["numberOfExpenses"] as! Int)
        }
    
    
        if (prefs["numberOfIncomes"] != nil) {
            mMyPreferences.setIncomeUsage(usage: prefs["numberOfIncomes"] as! Int)
        }
    
        if (prefs["isStatisticsOpened"] != nil) {
            mMyPreferences.setStatOpened(val: prefs["isStatisticsOpened"] as! Bool)
        }
    
    
        if (prefs["userLearnedCreateCategory"] != nil) {
            mMyPreferences.setLearnedAddCategory(val: prefs["userLearnedCreateCategory"] as! Bool)
        }
    
        if (prefs["userLearnedShare"] != nil) {
            mMyPreferences.setLearnedShare(val: prefs["userLearnedShare"] as! Bool)
        }
   
   
        if (prefs["userLearnedSwipeDelete"] != nil) {
            mMyPreferences.setLearnedWipe(val: prefs["userLearnedSwipeDelete"] as! Bool)
        }
    
        if (prefs["prefAskedFeedback"] != nil) {
            mMyPreferences.setPrefAskedFeedback(val: prefs["prefAskedFeedback"] as! Bool)
        }
    
        if (prefs["prefAskedFeedbackLater"] != nil) {
            mMyPreferences.setPrefAskedFeedbackLaster(val: prefs["prefAskedFeedbackLater"] as! Int)
        }
    
        if (prefs["userLearnedCreateCategory"] != nil) {
            mMyPreferences.setPrefAskedShare(val: prefs["userLearnedCreateCategory"] as! Bool)
        }
    
    
    
        if (prefs["prefAskedShareLater"] != nil) {
            mMyPreferences.setPrefAskedShareLater(val: prefs["prefAskedShareLater"] as! Int)
        }
    
        if (prefs["prefLicence"] != nil) {
            print("isUserPremium:: \(String(describing: prefs["prefLicence"]))")
            mMyPreferences.setLicence(val: prefs["prefLicence"] as!String)
        }
    
    
        if (prefs["prefLicenceChecked"] != nil) {
            mMyPreferences.setLearnedAddCategory(val: prefs["prefLicenceChecked"] as! Bool)
        }
    
    
        if (prefs["prefThemeChoose"] != nil) {
            mMyPreferences.setChooseTheme(val: prefs["prefThemeChoose"] as! Int)
        }
    
        if (prefs["prefCampaignBackup"] != nil) {
            mMyPreferences.setCampaignBackup(val: prefs["prefCampaignBackup"] as! Bool)
        }
   
        if (prefs["prefPinCode"] != nil) {
            mMyPreferences.setPINCode(val: prefs["prefPinCode"] as! String)
        }
    
        if (prefs["prefLoggedIn"] != nil) {
            mMyPreferences.setLoggedIn(val: prefs["prefLoggedIn"] as! Bool)
        }
    
        if (prefs["prefHelpCategory"] != nil) {
            mMyPreferences.setHelpCategory(val: prefs["prefHelpCategory"] as! Bool)
        }
    
        if (prefs["prefHelpExpense"] != nil) {
            mMyPreferences.setHelpExpense(val: prefs["prefHelpExpense"] as! Bool)
        }
    
        if (prefs["prefHelpIncome"] != nil) {
            mMyPreferences.setHelpIncome(val: prefs["prefHelpIncome"] as! Bool)
        }
    
        if (prefs["prefWidgetShowIncome"] != nil) {
            mMyPreferences.setShowWidgetIncome(val: prefs["prefWidgetShowIncome"] as! Bool)
        }
    
        if (prefs["prefWidgetShowExpense"] != nil) {
            mMyPreferences.setShowWidgetExpense(val: prefs["prefWidgetShowExpense"] as! Bool)
        }
    
        if (prefs["prefCheckLicenceTime"] != nil) {
            mMyPreferences.setNextCheck(val: prefs["prefCheckLicenceTime"] as! Int)
        }
    
    
        if (prefs["prefNotifiedForWidget"] != nil) {
            mMyPreferences.setNotifiedForWidget(val: prefs["prefNotifiedForWidget"] as! Bool)
        }
    
        if (prefs["prefNotifiedForTour"] != nil) {
            mMyPreferences.setNotifiedForTour(val: prefs["prefNotifiedForTour"] as! Bool)
        }
  
    
        if (prefs["prefEncoding"] != nil) {
            mMyPreferences.setEncoding(val: prefs["prefEncoding"] as! String)
        }
    
        if (prefs["prefRemindMissingBudget"] != nil) {
            mMyPreferences.setRemindMissingBudget(val: prefs["prefRemindMissingBudget"] as! Bool)
        }
    
        if (prefs["prefUserIdentifier"] != nil) {
            mMyPreferences.setUserIdentifier(val: prefs["prefUserIdentifier"] as! String)
        }
    
        if (prefs["prefUserEmail"] != nil) {
            mMyPreferences.setUserEmail(val:prefs["prefUserEmail"] as! String)
        }
    
        if (prefs["prefLearnedSwipeCategory"] != nil) {
            mMyPreferences.setLearnedWipeCategory(val:prefs["prefLearnedSwipeCategory"] as! Bool)
        }
    

        if (prefs["prefLearnedSwipeExpense"] != nil) {
            mMyPreferences.setLearnedWipeCategory(val:prefs["prefLearnedSwipeExpense"] as! Bool)
        }
    
    
        if (prefs["prefLearnedSwipeIncome"] != nil) {
            mMyPreferences.setLearnedWipeIncome(val:prefs["prefLearnedSwipeIncome"] as! Bool)
        }
    
        if (prefs["prefLearnedSwipeAccount"] != nil) {
            mMyPreferences.setLearnedWipeAccount(val:prefs["prefLearnedSwipeAccount"] as! Bool)
        }
    
        if (prefs["prefLearnedSwipePayee"] != nil) {
            mMyPreferences.setLearnedWipePayee(val:prefs["prefLearnedSwipePayee"] as! Bool)
        }
    
    
        if (prefs["prefLearnedSwipePayer"] != nil) {
            mMyPreferences.setLearnedWipePayer(val:prefs["prefLearnedSwipePayer"] as! Bool)
        }
    
    
        if (prefs["prefLearnedSwipeBudget"] != nil) {
            mMyPreferences.setLearnedWipeBudget(val:prefs["prefLearnedSwipeBudget"] as! Bool)
        }
    
        if (prefs["prefLearnedSwipeSchedule"] != nil) {
            mMyPreferences.setLearnedWipeSchedule(val:prefs["prefLearnedSwipeSchedule"] as! Bool)
        }
    
        if (prefs["prefTurnOnReminder"] != nil) {
            mMyPreferences.setReminderOn(val:prefs["prefTurnOnReminder"] as! Bool)
        }
    
        if (prefs["prefTurnOnNotifications"] != nil) {
            mMyPreferences.setNotificationOn(val:prefs["prefTurnOnNotifications"] as! Bool)
        }
    
        if (prefs["prefNewReminderScheduler"] != nil) {
            mMyPreferences.setResetNewReminder(val:prefs["prefNewReminderScheduler"] as! Bool)
        }
   
        if (prefs["prefCancelNextReminder"] != nil) {
            mMyPreferences.setCancelNextReminder(val:prefs["prefCancelNextReminder"] as! Bool)
        }
   
        if (prefs["prefLastReminderDateTime"] != nil) {
            mMyPreferences.setLastReminder(val:prefs["prefLastReminderDateTime"] as! Int)
        }
    
        if (prefs["prefLastSchedulerRun"] != nil) {
            mMyPreferences.setLastSchedulerRun(val:prefs["prefLastSchedulerRun"] as! Int)
        }
    
        if (prefs["prefDrawerActivities"] != nil) {
            mMyPreferences.setDrawerActivities(val:prefs["prefDrawerActivities"] as! Bool)
        }
    
        if (prefs["prefDrawerAccounts"] != nil) {
            mMyPreferences.setDrawerAccount(val: prefs["prefDrawerAccounts"] as! Bool)
        }
    
    
        if (prefs["prefDrawerHelp"] != nil) {
            mMyPreferences.setDrawerHelp(val:prefs["prefDrawerHelp"] as! Bool)
        }
    
        if (prefs["prefCreatedAccount"] != nil) {
            mMyPreferences.setCreatedAccount(val:prefs["prefCreatedAccount"] as! Bool)
        }
    
        if (prefs["prefNeverSignIn"] != nil) {
            mMyPreferences.setNeverSignIn(val:prefs["prefNeverSignIn"] as! Bool)
        }
    
        if (prefs["prefToken"] != nil) {
            mMyPreferences.setToken(val:prefs["prefToken"] as! String)
        }
    
    
        if (prefs["prefSubscriptionActive"] != nil) {
            mMyPreferences.setIsSubscriptionActive(val:prefs["prefSubscriptionActive"] as! Bool)
        }
    
        if (prefs["prefSubscriptionDue"] != nil) {
            mMyPreferences.setSubscriptionDueDate(val:prefs["prefSubscriptionDue"] as! Int)
        }
        
        if (prefs["selectedLanguage"] != nil) {
            
            mMyPreferences.setSelectedLanguage(lang: prefs["selectedLanguage"] as! String)
        }
        
    
    }
    
    
    public func toAnyObject() -> [String:Any] {
    
        var result:[String:Any] = [:]

        result["gid"] = gid
        result["selectedMonthlyBudget"] = selectedMonthlyBudget
        result["isFirstTime"] = isFirstTime
        result["dateFormat"] = dateFormat
        result["timeFormat"] = timeFormat
        result["settingDone"] = settingDone
        result["currency"] = currency
        result["hasPaidUnlimited"] = hasPaidUnlimited
        result["numberOfUse"] = numberOfUse
        result["numberOfExpenses"] = numberOfExpenses
        result["numberOfIncomes"] = numberOfIncomes
        result["isStatisticsOpened"] = isStatisticsOpened
        result["userLearnedCreateCategory"] = userLearnedCreateCategory
        result["userLearnedShare"] = userLearnedShare
        result["userLearnedSwipeDelete"] = userLearnedSwipeDelete
        result["prefAskedFeedback"] = prefAskedFeedback
        result["prefAskedFeedbackLater"] = prefAskedFeedbackLater
        result["prefAskedShare"] = prefAskedShare
        result["prefAskedShareLater"] = prefAskedShareLater
        result["prefLicence"] = prefLicence
        result["prefLicenceChecked"] = prefLicenceChecked
        result["prefThemeChoose"] = prefThemeChoose
        result["prefCampaignBackup"] = prefCampaignBackup
        result["prefPinCode"] = prefPinCode
        result["prefLoggedIn"] = prefLoggedIn
        result["prefHelpCategory"] = prefHelpCategory
        result["prefHelpExpense"] = prefHelpExpense
        result["prefHelpIncome"] = prefHelpIncome
        result["prefWidgetShowIncome"] = prefWidgetShowIncome
        result["prefWidgetShowExpense"] = prefWidgetShowExpense
        result["prefCheckLicenceTime"] = prefCheckLicenceTime
        result["prefNotifiedForWidget"] = prefNotifiedForWidget
        result["prefNotifiedForTour"] = prefNotifiedForTour
        result["prefEncoding"] = prefEncoding
        result["prefRemindMissingBudget"] = prefRemindMissingBudget
        result["prefUserIdentifier"] = prefUserIdentifier
        result["prefUserEmail"] = prefUserEmail
        result["prefLearnedSwipeCategory"] = prefLearnedSwipeCategory
        result["prefLearnedSwipeExpense"] = prefLearnedSwipeExpense
        result["prefLearnedSwipeIncome"] = prefLearnedSwipeIncome
        result["prefLearnedSwipeAccount"] = prefLearnedSwipeAccount
        result["prefLearnedSwipePayee"] = prefLearnedSwipePayee
        result["prefLearnedSwipePayer"] = prefLearnedSwipePayer
        result["prefLearnedSwipeBudget"] = prefLearnedSwipeBudget
        result["prefLearnedSwipeSchedule"] = prefLearnedSwipeSchedule
        result["prefTurnOnReminder"] = prefTurnOnReminder
        result["prefTurnOnNotifications"] = prefTurnOnNotifications
        result["prefNewReminderScheduler"] = prefNewReminderScheduler
        result["prefCancelNextReminder"] = prefCancelNextReminder
        result["prefLastReminderDateTime"] = prefLastReminderDateTime
        result["prefLastSchedulerRun"] = prefLastSchedulerRun
        result["prefDrawerActivities"] = prefDrawerActivities
        result["prefDrawerAccounts"] = prefDrawerAccounts
        result["prefDrawerHelp"] = prefDrawerHelp
        result["prefCreatedAccount"] = prefCreatedAccount
        result["prefNeverSignIn"] = prefNeverSignIn
        result["prefToken"] = prefToken
        result["prefSubscriptionActive"] = prefSubscriptionActive
        result["prefSubscriptionDue"] = prefSubscriptionDue
        result["selectedLanguage"] = selectedLanguage
        
        return result
    }
    
    

}

