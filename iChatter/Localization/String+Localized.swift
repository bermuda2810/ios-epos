//
//  String+Localized.swift
//  Project
//
//  Created by Bui Quoc Viet on 6/29/18.
//  Copyright © 2018 Mobile Team. All rights reserved.
//

import UIKit

protocol Localizable {
    var tableName: String { get }
    var localized: String { get }
}

extension Localizable where Self: RawRepresentable, Self.RawValue == String {
    var localized: String {
        return rawValue.localized(tableName: tableName)
    }
}

enum NetworkError : String, Localizable {
    var tableName: String {
        return "LocalizationNetworkError"
    }
    case serverError = "Server Error"
    case noConnection = "No internet connection"
    case timeout = "Request timeout"
    case connectionTimeout = "Connection timeout"
}

enum Common : String, Localizable {
    var tableName: String {
        return "LocalizationCommon"
    }
    case succeed = "Succeed"
    case done = "Done"
    case cancel = "Cancel"
    case failed = "Failed"
    case loading = "Loading"
    case retry = "Retry"
    case alert = "Alert"
    case okay = "Okay"
    case notEmpty = "Not empty"
    case close = "Close"
}

enum CurriculumScreen : String, Localizable {
    var tableName: String {
        return "LocalizationCurriculum"
    }
    case attachments = "attachments"
    case links = "links"
    case hour = "hour"
    case hours = "hours"
    case unit = "Unit"
    case lesson = "Lesson"
}

enum LoginScreen : String, Localizable {
    var tableName: String {
        return "LocalizationLoginScreen"
    }
    case loginFail = "Login fail!"
    case theUserCredentialsWereIncorrect = "The user credentials were incorrect."
}

enum TimezoneScreen : String, Localizable {
    var tableName: String {
        return "LocalizationTimeZoneScreen"
    }
    case search = "Search"
    case selectedTimezone = "Selected timezone"
    case topTimezoneMatches = "Top timezone matches"
    case timezoneWasChanged = "Timezone was changed"
}

enum ForgotPasswordScreen : String, Localizable {
    var tableName: String {
        return "LocalizationForgotPassword"
    }
    case theUserCredentialsWereIncorrect = "The user credentials were incorrect."
    case succeed = "Succeed"
}

enum SettingsScreen : String, Localizable {
    var tableName: String {
        return "LocalizationSettingsScreen"
    }
    case settings = "Settings"
}

enum LanguageScreen : String, Localizable {
    var tableName: String {
        return "LocalizationLanguageScreen"
    }
    case vietnamese = "Vietnamese"
    case english = "English"
    case languageChanged = "Changed language"
}

enum MyProfileScreen : String, Localizable {
    var tableName: String {
        return "LocalizationMyProfile"
    }
    case male = "Male"
    case female = "Female"
    case other = "Other"
    case avatarTooSmall = "Your avatar too small"
    case emailNotValid = "Email is not valid"
    case displayNameNotValid = "Display name is not valid"
    case phoneNumberNotValid = "Phone number is not valid"
    case skypeNotValid = "Skype is not valid"
    case updateFailed = "Update failed"
}

enum ChangeNationScreen : String, Localizable {
    var tableName: String {
        return "LocalizationChangeNation"
    }
    case currentNation = "Currrent Nation"
    case searchNation = "Search nation"
    case topNationMatches = "Top nation matches"
}

enum ChangePhoneCodeScreen : String, Localizable {
    var tableName: String {
        return "LocalizationChangePhoneCode"
    }
    case currentPhonecode = "Current phone code"
    case searchPhonecode = "Search phone code"
    case topCodeMatches = "Top code matches"
}

enum ChangePasswordScreen : String, Localizable {
    var tableName: String {
        return "LocalizationChangePassword"
    }
    case oldPassword = "Old password"
    case newPassword = "New password"
    case confirmNewpassword = "Confirm new password"
    case oldPasssNotValid = "Old password is not valid"
    case newPassNotValid = "New password is not valid"
    case confirmPassNotValid = "Confirm password is not valid"
    case passwordNotMatch = "Password does not match the confirm password"
    case passwordChangeFailed = "Password change failed"
    case passwordChanged = "Password changed"
}

enum CourseScreen : String, Localizable {
    var tableName: String {
        return "LocalizationCourse"
    }
    case course = "Course"
    case curriculum = "Curriculum"
    case sessions = "Sessions"
    case menu = "Menu"
    case close = "Close"
    case today = "Today"
    case tapToDownload = "Tap to Download"
}

enum SettingsCoursesScreen : String, Localizable {
    var tableName: String {
        return "LocalizationSettingsCourses"
    }
    case teachingCourses = "Teaching courses"
    case learningCourses = "Learning courses"
    case matchingRequest = "Matching request"
    case all = "All"
    case open = "Open"
    case delay = "Delay"
    case closed = "Closed"
    case cancel = "Cancel"
    case startedAt = "Started At"
    case studentsName = "Student’s name"
    case teacherName = "Teacher's name"
    case hours = "hours"
    case upcomingSession = "Upcoming session"
    case upcomingSessionWasUnscheduled = "Upcoming session was unscheduled"
    case teacher = "TEACHER"
    case learner = "LEARNER"
}

enum MatchingAvailableScreen : String, Localizable {
    var tableName: String {
        return "LocalizationMatchingAvailable"
    }
    case work = "Work"
    case kid = "Kid"
    case available = "Available"
    case applied = "Applied"
    case all = "All"
    case waiting = "Waiting"
    case approved = "Approved"
    case rejected = "Rejected"
    case placeholderApplyBox = "Placeholder ApplyBox"
}

enum MatchingRequestDetailScreen: String, Localizable {
    var tableName: String {
        return "LocalizationMatchingRequestDetail"
    }
    
    case requestAt = "Request at"
    case age = "Age:"
    case level = "Level:"
    case seeMore = "See more"
    case apply = "Apply"
    case youCannotRequest = "You cannot apply this request"
    case courseTime = "Course time:"
    case scheduleTime = "Schedule time:"
    case availableTime = "Available times:"
    case requests = "Requests"
    case appliedAt = "Applied at"
    case approvedAt = "Approved at"
    case rejectedAt = "Rejected at"
}

enum ApplicantsScreen: String, Localizable {
    var tableName: String {
        return "LocalizationApplicants"
    }
    
    case applicants = "Applicants"
}

enum SessionDetailScreen: String, Localizable {
    var tableName: String {
        return "LocalizationSessionScreen"
    }
    case studentWasLate = "Student was late"
    case studentWasAbsent = "Student was absent"
    case withoutAnyNotice = "without any notice"
    case placeHolderTeacherAbsent = "place_holder_teacher_absent"
    case placeHolderLearnerAbsent = "place_holder_learn_absent"
    case poor = "Poor"
    case fair = "Fair"
    case good = "Good"
    case veryGood = "Very good"
    case excellent = "Excellent"
    case learner = "LEARNER"
    case teacher = "TEACHER"
    case required = "required"
    case minimum120char = "minimum_120char"
    case deleteSession = "Delete this session"
    case pingStudent = "Ping student"
    case changeDateTime = "Change date/time"
    case changeType = "Change type"
    case notableTeachSession = "Not able to teach this session"
    case confirmSession = "Confirm this session"
    case pingTeacher = "Ping teacher"
    case notableLearnSession = "Not able to learn this session"
    case teacherWasAbsent = "Teacher was absent"
    case teacherWasLate = "Teacher was late"
    case changedTo = "Changed to"
    case byTeacher = "by teacher"
    case byStudent = "by student"
    case tapToChangeDateTime = "TAP TO CHANGE DATE/TIME"
    case youConfirmThisSession = "You confirmed this session"
    case tapToUndo = "TAP TO UNDO"
    case teacherConfirm = "TEACHER CONFIRMED!"
    case teacherUnConfirm = "TEACHER UNCONFIRMED!"
    case studentConfirm = "STUDENT CONFIRMED!"
    case studentUnConfirm = "STUDENT UNCONFIRMED!"
    case tapToConfirm = "TAP TO CONFIRM"
    case tapToUnConfirm = "TAP TO UNCONFIRM"
    case youConfirm = "YOU CONFIRMED!"
    case youUnConfirm = "YOU UNCONFIRMED!"
    case studentReadIt = "STUDENT READ IT!"
    case teacherReadIt = "TEACHER READ IT!"
    case tapToConfirmReadIt = "TAP TO CONFIRM THAT YOU READ IT!"
    case readIt = "READ IT!"
    case urlNotNull =  "URL must not be empty"
    case studentDisagreed = "STUDENT DISAGREED!"
    case teacherDisagreed = "TEACHER DISAGREED!"
    case tapToDisagree = "TAP TO DISAGREE"
    case youDisagree = "YOU DISAGREED!"
    case areYouSureDelete = "Are sure delete"
    case within30Minutes = "within 30 minutes"
}

enum SessionScreen : String, Localizable {
    var tableName: String {
        return "LocalizationSessionScreen"
    }
    case week = "WEEK"
    case session = "session"
    case sessions = "sessions"
    case tapHereToScheduleThisSession = "Tap here to schedule this session"
    case topTeacher = "top_teacher"
    case topStudent = "top_student"
    case cancelEditing = "Cancel editing"
    case edit = "Edit"
}

enum TitleNavigation : String, Localizable {
    var tableName: String {
        return "LocalizationTitleNavigation"
    }
    case notifications = "Notifications"
    case account = "Account"
    case myProfile = "My Profile"
    case changePhoneCode = "Change Phone Code"
    case changeNation = "Change Nation"
    case timezone = "Timezone"
    case language = "Language"
    case settings = "Settings"
    case support = "Support"
    case about = "About"
}

enum ReviewsFeedbacksScreen : String, Localizable  {
    var tableName: String {
        return "LocalizationReviewsFeedbacks"
    }
    case hour = "hour"
    case hours = "hours"
    case LEARNER = "LEARNER"
    case TEACHER = "TEACHER"
    case wroteAt = "Wrote at"
    case reviews = "Reviews"
    case feedbacks = "Feedbacks"
    case reviewSingle = "Review(%d)"
    case reviewPlural = "Reviews(%d)"
    case feedbackSingle = "Feedback(%d)"
    case feedbackPlural = "Feedbacks(%d)"
    case reasonCantPostReview = "This is the reason for not being able to post a review"
    case cannotPostReview = "Cannot post a review!"
    case shareWithStudent = "Share with Student";
    case shareWithTeacher = "Share with Teacher";
}

extension String {
    func localized(tableName: String = "", _ bundle: Bundle = .main) -> String {
        return NSLocalizedString(self, tableName: tableName, bundle : bundle, value: "**\(self)**", comment: "")
    }
}
