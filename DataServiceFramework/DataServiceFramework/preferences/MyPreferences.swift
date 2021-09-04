//
//  MyPreferences.swift
//  iSaveMoney
//
//  Created by Armel Koudoum on 7/3/16.
//  Copyright © 2016 UlmatCorpit. All rights reserved.
//

import Foundation


public class MyPreferences {
    
    
    let CURRENT_USER_GID = "current_user_gid"
    let CURRENT_USER_EMAIL = "current_user_email"
    let CURRENCY_LOCAL = "currency_local"
    let DATE_FORMAT = "date_format"
    let TIME_FORMAT = "time_format"
    //
    let SELECTED_LANGUAGE = "selected_language"
    
    let SELECTED_MONTHLY_BUDGET = "selected_monthly_budget"
    let IS_FIRST_TIME = "IsFirstTime"
    let PREF_DATE_FORMAT = "date_format"
    let PREF_TIME_FORMAT = "time_format"
    let PREF_SETTING_DONE = "setting_done"
    let USER_CURRENCY = "currency"
    let HAS_PAID_UNLIMITED = "has_paid_unlimited"
    let NUMBER_OF_USE = "number_of_use"
    let NUMBER_OF_EXPENSES = "number_of_expenses"
    let NUMBER_OF_INCOMES = "number_of_incomes"
    let PREF_STATISTIC_OPENED = "is_statistics_opened"
    let PREF_USER_LEARNED_CREATE_CATEGORY = "user_learned_create_category"
    let PREF_USER_LEARNED_SHARE = "user_learned_share"
    let PREF_USER_LEARNED_SWIPE_DELETE = "user_learned_wipe_delete"
    let PREF_ASKED_FEEDBACK = "pref_asked_feedback"
    let PREF_ASKED_FEEDBACK_LATER = "pref_asked_feedback_later"
    let PREF_ASKED_SHARE = "pref_asked_share"
    let PREF_ASKED_SHARE_LATER = "pref_asked_share_later"
    let PREF_LICENCE = "pref_licence"
    let PREF_LICENCE_CHECKED = "pref_licence_checked"
    let PREF_THEME_CHOOSE = "pref_theme_choose"
    
    let PREF_CAMPAIGN_BACKUP = "pref_campaign_backup"
    let PREF_PIN_CODE = "pref_pin_code"
    let PREF_LOGGED_IN = "pref_logged_in"
    
    let PREF_HELP_CATEGORY = "pref_help_category"
    let PREF_HELP_EXPENSE = "pref_help_expense"
    let PREF_HELP_INCOME = "pref_help_income"

    let PREF_WIDGET_SHOW_INCOME = "pref_widget_show_income"
    let PREF_WIDGET_SHOW_EXPENSE = "pref_widget_show_expense"
    
    let PREF_CHECK_LICENCE_TIME = "pref_check_licence_time"
    let PREF_NOTIFIED_FOR_WIDGET = "pref_notified_for_widget"
    let PREF_NOTIFIED_TOUR = "pref_notified_for_tour"
    let PREF_ENCODING = "pref_encoding"
    let PREF_REMIND_MISSING_BUDGET = "pref_remind_missing_budget"
    let PREF_USER_IDENTIFIER = "pref_user_identifier"
    let PREF_USER_EMAIL = "pref_user_email"
    
    let PREF_LEARNED_SWIPE_CATEGORY = "pref_learned_swipe_category"
    let PREF_LEARNED_SWIPE_EXPENSE = "pref_learned_swipe_expense"
    let PREF_LEARNED_SWIPE_INCOME = "pref_learned_swipe_income"
    let PREF_LEARNED_SWIPE_ACCOUNT = "pref_learned_swipe_account"
    let PREF_LEARNED_SWIPE_PAYEE = "pref_learned_swipe_payee"
    let PREF_LEARNED_SWIPE_PAYER = "pref_learned_swipe_payer"
    let PREF_LEARNED_SWIPE_BUDGET = "pref_learned_swipe_budget"
    let PREF_LEARNED_SWIPE_SCHEDULE = "pref_learned_swipe_schedule"
    let PREF_TURN_ON_REMINDER = "pref_turn_on_reminder"
    let PREF_TURN_ON_NOTIFICATIONS = "pref_turn_on_notifications"
    
    let PREF_NEW_REMINDER_SETTINGS = "pref_new_reminder_scheduler"
    let PREF_CANCEL_NEXT_REMINDER = "pref_cancel_next_reminder"
    let PREF_LAST_REMINDER_DATE_TIME = "pref_last_reminder_date_time"
    let PREF_LAST_SCHEDULER_RUN = "pref_last_scheduler_run"
    
    let PREF_DRAWER_ACTIVITIES = "pref_drawer_activities"
    let PREF_DRAWER_ACCOUNTS = "pref_drawer_accounts"
    let PREF_DRAWER_HELP = "pref_drawer_help"
    let PREF_CREATED_ACCOUNT = "pref_created_account"
    let PREF_NEVER_SIGN_IN = "pref_never_sign_in"
    let PREF_TOKEN = "pref_token"
    let PREF_SUBSCRIPTION_ACTIVE = "pref_subscription_active"
    let PREF_SUBSCRIPTION_DUE = "pref_subscription_due"
    
    let PREF_APP_CODE_UNLOCK = "pref_app_code_unlock"

    
    
    var defaults:UserDefaults
    
    
    public init() {
        defaults = UserDefaults.standard
    }
    
    public func setUnlockCode(_ guid: String) -> Void {
        
        defaults.set(guid, forKey: self.PREF_APP_CODE_UNLOCK)
        
    }
    
    public func getUnlockCode() -> String {
        
        return defaults.string(forKey: self.PREF_APP_CODE_UNLOCK) ?? ""
    }
    
    
    public func migratePreferences() {
        
        setUserIdentifier(val: defaults.string(forKey: self.CURRENT_USER_GID) ?? "")
        setUserEmail(val: defaults.string(forKey: self.CURRENT_USER_EMAIL) ?? "")
        setCurrency(defaults.string(forKey: self.CURRENCY_LOCAL) ?? "")
        setDateFormat(defaults.string(forKey: PREF_DATE_FORMAT) ?? "MM/dd/yyyy")
        setTimeFormat(defaults.string(forKey: PREF_TIME_FORMAT) ?? "hh:mm a")
    }
    
    public func destroy()  {
        
        //if let bundleID = Bundle.main.bundleIdentifier {
            //UserDefaults.standard.removePersistentDomain(forName: bundleID)
        //}
    }
    //Current budget
    public func setSelectedMonthlyBudget(_ guid: String) -> Void {
        
        defaults.set(guid, forKey: self.SELECTED_MONTHLY_BUDGET)
        
    }
    
    public func getSelectedMonthlyBudget() -> String {
        
        return defaults.string(forKey: self.SELECTED_MONTHLY_BUDGET) ?? ""
    }
    //selected language
    public func setSelectedLanguage(lang: String) -> Void {
        
        defaults.set(lang, forKey: self.SELECTED_LANGUAGE)
        
    }
    
    public func getSelectedLanguage() -> String {
        
        return defaults.string(forKey: self.SELECTED_LANGUAGE) ?? ""
    }
    
    
    
    // get and set currency
    public func setCurrency(_ local: String) -> Void {
        
        defaults.set(local, forKey: self.USER_CURRENCY)
    }
    
    public func getCurrency() -> String {
        
        return defaults.string(forKey: self.USER_CURRENCY) ?? ""
        
    }
    
    //time format
    public func setTimeFormat(_ time: String) -> Void {
        
        defaults.set(time, forKey: self.PREF_TIME_FORMAT)
    }
    
    //date format
    public func setDateFormat(_ date: String) -> Void {
        
        defaults.set(date, forKey: self.PREF_DATE_FORMAT)
    }
    
    
    //get time format
    public func getTimeFormat() -> String {
        
        return defaults.string(forKey: self.PREF_TIME_FORMAT) ?? "hh:mm a"
    }
    
    //get date format
    public func getDateFormat() -> String {
        
        var format = defaults.string(forKey: self.PREF_DATE_FORMAT) ?? "mm/dd/yyyy"
        return format.replacingOccurrences(of: "m", with: "M")
    }
    
    
    
    ///New from android
    public func  getToken() -> String{
    
        return defaults.string(forKey: self.PREF_TOKEN) ?? ""
        
    }
    
    public func setToken(val:String) {

        defaults.set(val, forKey: self.PREF_TOKEN)
    }
    
    public func isNeverSignIn() -> Bool{
    
        return  defaults.bool(forKey: PREF_NEVER_SIGN_IN)
    }
    
    public func setNeverSignIn(val:Bool) {
    
        defaults.set(val, forKey: PREF_NEVER_SIGN_IN)
   
    }
    
    //set created account
    public func getCreatedAccount() -> Bool {
        
        return defaults.bool(forKey: PREF_CREATED_ACCOUNT)
        
    }
    
    public func setCreatedAccount(val: Bool) {
        defaults.set(val, forKey: PREF_CREATED_ACCOUNT)
    }
    
    //set drawer activities
    public func getDrawerActivities() -> Bool {
        return defaults.bool(forKey: PREF_DRAWER_ACTIVITIES)
    }
    public func setDrawerActivities(val: Bool) {
        defaults.set(val, forKey: PREF_DRAWER_ACTIVITIES)
    }
    
    //set drawer activities
    public func getDrawerAccount() -> Bool{
        return defaults.bool(forKey: PREF_DRAWER_ACCOUNTS)
    
    }
    public func setDrawerAccount(val:Bool) {
        defaults.set(val, forKey: PREF_DRAWER_ACCOUNTS)
    }
    
    //set drawer activities
    public func getDrawerHelp() -> Bool {
        return defaults.bool(forKey: PREF_DRAWER_HELP)
    }
    public func setDrawerHelp(val:Bool) {
        defaults.set(val, forKey: PREF_DRAWER_HELP)
    }
    
    
    
    //set last reminder
    public func getLastReminder() -> Int{
        return defaults.integer(forKey: PREF_LAST_REMINDER_DATE_TIME)
    }
    
    public func setLastReminder(val:Int) {
        defaults.set(val, forKey: PREF_LAST_REMINDER_DATE_TIME)
    }
    //set last scheduler run
    public func getLastSchedulerRun() -> Int {
        return defaults.integer(forKey: PREF_LAST_SCHEDULER_RUN)
    
    }
    
    public func setLastSchedulerRun(val:Int) {

        defaults.set(val, forKey: PREF_LAST_SCHEDULER_RUN)
    }
    
    public func didCancelNextReminder() -> Bool{
        return defaults.bool(forKey: PREF_CANCEL_NEXT_REMINDER)
   
    }
    
    public func setCancelNextReminder(val:Bool) {
        
        defaults.set(val, forKey: PREF_CANCEL_NEXT_REMINDER)
   
    }
    
    //
    public func didResetNewReminder() -> Bool {
        return defaults.bool(forKey: PREF_NEW_REMINDER_SETTINGS)

    }
    
    public func setResetNewReminder(val:Bool){
        return defaults.set(val, forKey: PREF_NEW_REMINDER_SETTINGS)
    }
    
    
    //turn notification
    public func isNotificationsOn() -> Bool {
        return defaults.bool(forKey: PREF_TURN_ON_NOTIFICATIONS)
    }
    
    public func setNotificationOn(val:Bool) {
        defaults.set(val, forKey: PREF_TURN_ON_NOTIFICATIONS)
    }
    
    //turn reminder
    public func isReminderOn() -> Bool{
        return defaults.bool(forKey: PREF_TURN_ON_REMINDER)
    }
    
    public func setReminderOn(val:Bool) {
        defaults.set(val, forKey: PREF_TURN_ON_REMINDER)
    }
    
    public func isFirstTime() -> Bool{
        return defaults.bool(forKey: IS_FIRST_TIME)
    }
    
    public func setIsFirstTime(val: Bool) {
        defaults.set(val, forKey: IS_FIRST_TIME)
    }
    
    /**
     * get the current and active budget
     * @return
     */
    public func getCurrentId() -> String{
        return defaults.string(forKey: SELECTED_MONTHLY_BUDGET) ?? ""

    }
    /**
     * save selected budget
     * @param budget_did
     */
    public func setSelectedBudget(budget_did:String) {
        defaults.set(budget_did, forKey: SELECTED_MONTHLY_BUDGET)
    }
    
    //unlimited
    public func getPaidUnlimited() -> Bool{
        return defaults.bool(forKey: HAS_PAID_UNLIMITED)
    }
    
    public func setPaidUnlimited(val:Bool){
        defaults.set(val, forKey: HAS_PAID_UNLIMITED)
    }
    
    //
    public func getAppUsage() -> Int{
        return defaults.integer(forKey: NUMBER_OF_USE)
    }
    
    public func setAppUsage(){
        defaults.set(getAppUsage()+1, forKey: NUMBER_OF_USE)
    }
    
    public func setAppUsage(usage:Int){
        defaults.set(usage, forKey: NUMBER_OF_USE)
    }
    
    //Expenses added
    public func getExpenseUsage() -> Int{
        return defaults.integer(forKey: NUMBER_OF_EXPENSES)
    }
    
    public func setExpenseUsage(){
        defaults.set(getExpenseUsage()+1, forKey: NUMBER_OF_EXPENSES)
    }
    public func setExpenseUsage(usage:Int){
        defaults.set(usage, forKey: NUMBER_OF_EXPENSES)

    }
    
    
    //Income added
    public func getIncomeUsage() -> Int{
        return defaults.integer(forKey: NUMBER_OF_INCOMES)
    
    }
    
    public func setIncomeUsage(){
        defaults.set(getIncomeUsage()+1, forKey: NUMBER_OF_INCOMES)
    }
    public func setIncomeUsage(usage:Int){
        defaults.set(usage, forKey: NUMBER_OF_INCOMES)
    }
    
    public func setAppUsages(val:Int){
        defaults.set(val, forKey: NUMBER_OF_USE)
    }
    
    //stat open
    public func isStatOpened() -> Bool{
        return defaults.bool(forKey: PREF_STATISTIC_OPENED)
    //return pref.getBoolean(PREF_STATISTIC_OPENED, true);
    }
    
    public func setStatOpened(val:Bool){
        defaults.set(val, forKey: PREF_STATISTIC_OPENED)
    
    }
    
    
    //learned create BudgetCategory
    public func didLearnedAddCategory() -> Bool{
        return defaults.bool(forKey: PREF_USER_LEARNED_CREATE_CATEGORY)
    }
    
    public func setLearnedAddCategory(val:Bool){
        defaults.set(val, forKey: PREF_USER_LEARNED_CREATE_CATEGORY)
    
    }
    //learned create BudgetCategory
    public func didLearnedShare() -> Bool{
        return defaults.bool(forKey: PREF_USER_LEARNED_SHARE)
    }
    
    public func setLearnedShare(val:Bool){
        return defaults.set(val, forKey: PREF_USER_LEARNED_SHARE)
    }
    //learned  wipe delete
    public func didLearnedWipe() -> Bool{
        return defaults.bool(forKey: PREF_USER_LEARNED_SWIPE_DELETE)
    }
    
    public func setLearnedWipe(val:Bool){
        defaults.set(val, forKey: PREF_USER_LEARNED_SWIPE_DELETE)
   
    }
    
    //asked for feedback
    public func setPrefAskedFeedback(val:Bool){
        defaults.set(val, forKey: PREF_ASKED_FEEDBACK)
    }
    
    public func getPrefAskedFeedback() -> Bool {
        return defaults.bool(forKey: PREF_ASKED_FEEDBACK) ?? false
    }
    
    //next feedback
    
    public func setPrefAskedFeedbackLaster(val:Int){
        defaults.set(val, forKey: PREF_ASKED_FEEDBACK_LATER)
    }
    
    public func getPrefAskedFeedbackLaster() -> Int {
        return defaults.integer(forKey: PREF_ASKED_FEEDBACK_LATER)
    
    }

    //asked for share
    public func setPrefAskedShare(val:Bool){
        defaults.set(val, forKey: PREF_ASKED_SHARE)
    }
    
    public func getPrefAskedShare() -> Bool{
        return defaults.bool(forKey: PREF_ASKED_SHARE)
    }
    
    //next share
    
    public func setPrefAskedShareLater(val:Int){
        defaults.set(val, forKey: PREF_ASKED_SHARE_LATER)
    
    }
    
    public func getPrefAskedShareLater() -> Int{
        return defaults.integer(forKey: PREF_ASKED_SHARE_LATER)
    }
    
    // licence
    public func  getLicence() -> String {
        return defaults.string(forKey: PREF_LICENCE) ?? "unknown"
    }
    
    public func setLicence( val: String) {
        defaults.set(val, forKey: PREF_LICENCE)
    }
    
    //is licence checked
    // licence
    public func getIsLicence() -> Bool {
        return defaults.bool(forKey: PREF_LICENCE_CHECKED) ?? false
    }
    
    public func setIsLicence(val:Bool) {
        defaults.set(val, forKey: PREF_LICENCE_CHECKED)
    }
    
    //subscription
    public func getIsSubscriptionActive() -> Bool {
        return defaults.bool(forKey: PREF_SUBSCRIPTION_ACTIVE) ?? false
    }
    
    public func setIsSubscriptionActive(val:Bool) {
        defaults.set(val, forKey: PREF_SUBSCRIPTION_ACTIVE)
    }
    
    public func getSubscriptionDueDate() -> Int {
        return defaults.integer(forKey: PREF_SUBSCRIPTION_DUE) ?? 0
    
    }
    
    public func setSubscriptionDueDate(val:Int) {
    
        defaults.set(val, forKey: PREF_SUBSCRIPTION_DUE)
    }
    
    
    
    
    public func getCampaignBackup() -> Bool{
        return defaults.bool(forKey: PREF_CAMPAIGN_BACKUP) ?? false
    
    }
    
    public func setCampaignBackup(val:Bool) {
        defaults.set(val, forKey: PREF_CAMPAIGN_BACKUP)
    }
    
    
    //choose theme
    
    public func getChooseTheme() -> Int{
        return defaults.integer(forKey: PREF_THEME_CHOOSE)
    }
    
    public func setChooseTheme(val:Int) {
        defaults.set(val, forKey: PREF_THEME_CHOOSE)
    }
    
    
    //PIN code
    
    public func  getPINCode() -> String {
        return defaults.string(forKey: PREF_PIN_CODE) ?? ""
    }
    
    public func setPINCode(val: String) {
        defaults.set(val, forKey: PREF_PIN_CODE)
    }
    
    
    //logged in
    
    public func isLoggedIn() -> Bool {
        
        return defaults.bool(forKey: PREF_LOGGED_IN) ?? false
    }
    
    public func setLoggedIn(val:Bool) {
    
        defaults.set(val, forKey: PREF_LOGGED_IN)
    }
    
    
    //show income in widget
    
    public func showWidgetIncome() -> Bool {
        return defaults.bool(forKey: PREF_WIDGET_SHOW_INCOME) 
    }
    
    public func setShowWidgetIncome(val:Bool) {
    
        defaults.set(val, forKey: PREF_WIDGET_SHOW_INCOME)
    }
    
    //show expense in widget
    
    public func showWidgetExpense() -> Bool {
        return defaults.bool(forKey: PREF_WIDGET_SHOW_EXPENSE) 
    }
    
    public func setShowWidgetExpense(val: Bool) {
        defaults.set(val, forKey: PREF_WIDGET_SHOW_EXPENSE)
    }
    
    ///
    
    public func canCheckLicence() -> Bool {
    
        let nextCheck = defaults.integer(forKey: PREF_CHECK_LICENCE_TIME)

        return nextCheck <= Int(Date().timeIntervalSince1970*1000)
    }
    public func getCheckLicence() -> Int {
        
        let nextCheck = defaults.integer(forKey: PREF_CHECK_LICENCE_TIME)
        
        return nextCheck
    }
    
    public func setNextCheck(val:Int) {
        defaults.set(val, forKey: PREF_CHECK_LICENCE_TIME)
    }
    
    ///
    public func isNotifiedForWidget() -> Bool {
        return defaults.bool(forKey: PREF_NOTIFIED_FOR_WIDGET)
    }
    
    public func setNotifiedForWidget(val:Bool) {
        defaults.set(val, forKey: PREF_NOTIFIED_FOR_WIDGET)
    }
    
    /// Notify for tour
    public func isNotifiedForTour() -> Bool {
        return defaults.bool(forKey: PREF_NOTIFIED_TOUR)
    }
    
    public func setNotifiedForTour(val:Bool) {
        defaults.set(val, forKey: PREF_NOTIFIED_TOUR)
    }
    
    //encoding
    public func  getEncoding() -> String {
    
        return defaults.string(forKey: PREF_ENCODING) ?? ""

    }
    
    public func setEncoding( val:String) {
        defaults.set(val, forKey: PREF_ENCODING)
    }
    
    //
    public func isSettingDone() -> Bool{
    
        return defaults.bool(forKey: PREF_SETTING_DONE)
    }
    
    public func setSettingDone(val:Bool) {
        return defaults.set(val, forKey: PREF_SETTING_DONE)
    }
    
    
    //
    public func canRemindMissingBudget() -> Bool {
        return defaults.bool(forKey: PREF_REMIND_MISSING_BUDGET)
    }
    
    public func setRemindMissingBudget(val:Bool) {
        defaults.set(val, forKey: PREF_REMIND_MISSING_BUDGET)
    }
    
    //help category
    public func helpCategory() -> Bool {
        return defaults.bool(forKey: PREF_HELP_CATEGORY)
    }
    
    public func setHelpCategory(val:Bool) {
        defaults.set(val, forKey: PREF_HELP_CATEGORY)
  
    }
    
    //help expense
    public func helpExpense() -> Bool {
        return defaults.bool(forKey: PREF_HELP_EXPENSE)
    
    }
    
    public func setHelpExpense(val:Bool) {
        defaults.set(val, forKey: PREF_HELP_EXPENSE)
    }
    
    //help income
    public func helpCIncome() -> Bool{
        return defaults.bool(forKey: PREF_HELP_INCOME) ?? true
    }
    
    public func setHelpIncome(val:Bool) {
        defaults.set(val, forKey: PREF_HELP_INCOME)
    }
    
    
    //user identifier
    public func getUserIdentifier() -> String{
        return defaults.string(forKey: PREF_USER_IDENTIFIER) ?? "anonimous"
    }
    
    public func setUserIdentifier(val:String) {
        return defaults.set(val, forKey: PREF_USER_IDENTIFIER)

    }
    
    //user e-mail
    public func getUserEmail() -> String {
        
        return defaults.string(forKey: PREF_USER_EMAIL) ?? ""
    }
    
    public func setUserEmail( val:String) {
        defaults.set(val, forKey: PREF_USER_EMAIL)
    }
    
    
    ////////////////////////
    /**********************/
    //learned  swipe BudgetCategory
    public func didLearnedWipeCategory() -> Bool{
        return defaults.bool(forKey: PREF_LEARNED_SWIPE_CATEGORY) ?? false
    }
    
    public func setLearnedWipeCategory(val:Bool){
        defaults.set(val, forKey: PREF_LEARNED_SWIPE_CATEGORY)
    }
    
    //learned  swipe income
    public func didLearnedWipeIncome() -> Bool{
        return defaults.bool(forKey: PREF_LEARNED_SWIPE_INCOME) ?? false
    }
    
    public func setLearnedWipeIncome( val:Bool){
        defaults.set(val, forKey: PREF_LEARNED_SWIPE_INCOME)
    }
    
    //learned  swipe expense
    public func didLearnedWipeExpense() -> Bool{
        return defaults.bool(forKey: PREF_LEARNED_SWIPE_EXPENSE) ?? false
    }
    
    public func setLearnedWipeExpense(val:Bool){
        defaults.set(val, forKey: PREF_LEARNED_SWIPE_EXPENSE)
    }
    
    //learned  swipe account
    public func didLearnedWipeAccount() -> Bool{
        return defaults.bool(forKey: PREF_LEARNED_SWIPE_ACCOUNT)
    }
    
    public func setLearnedWipeAccount(val:Bool){
        defaults.set(val, forKey: PREF_LEARNED_SWIPE_ACCOUNT)
    }
    
    //learned  swipe payee
    public func didLearnedWipePayee() -> Bool{
        return defaults.bool(forKey: PREF_LEARNED_SWIPE_PAYEE)
    }
    
    public func setLearnedWipePayee(val:Bool){
        defaults.set(val, forKey: PREF_LEARNED_SWIPE_PAYEE)
    }
    
    //learned  swipe BudgetCategory
    public func didLearnedWipePayer() -> Bool{
        return defaults.bool(forKey: PREF_LEARNED_SWIPE_PAYER)
    }
    
    public func setLearnedWipePayer(val: Bool){
        defaults.set(val, forKey: PREF_LEARNED_SWIPE_PAYER)
    }
    
    //learned  swipe budget
    public func didLearnedWipeBudget() -> Bool{
        return defaults.bool(forKey: PREF_LEARNED_SWIPE_BUDGET) ?? false
    }
    
    public func setLearnedWipeBudget(val:Bool){
        defaults.set(val, forKey: PREF_LEARNED_SWIPE_BUDGET)
    }
    
    //learned  swipe schedule
    public func didLearnedWipeSchedule() -> Bool{
        return defaults.bool(forKey: PREF_LEARNED_SWIPE_SCHEDULE) ?? false
    
    }
    
    public func setLearnedWipeSchedule(val: Bool){
        defaults.set(val, forKey: PREF_LEARNED_SWIPE_SCHEDULE)
    
    }

}
