import SwiftUI

enum Translation {

    enum Schedule {
        static let title = LocalizedStringKey("schedule_title")
        static let group = LocalizedStringKey("schedule_group_label")

        static let monday = LocalizedStringKey("schedule_day_mon")
        static let tuesday = LocalizedStringKey("schedule_day_tue")
        static let wednesday = LocalizedStringKey("schedule_day_wed")
        static let thursday = LocalizedStringKey("schedule_day_thu")
        static let friday = LocalizedStringKey("schedule_day_fri")
        static let saturday = LocalizedStringKey("schedule_day_sat")
        static let noLessonsSunday = LocalizedStringKey("schedule_no_lessons_sunday")
    }

    enum LessonType {
        static let lecture = LocalizedStringKey("lesson_type_lecture")
        static let seminar = LocalizedStringKey("lesson_type_seminar")
        static let lab = LocalizedStringKey("lesson_type_lab")
    }

    enum Grades {
        static let title = LocalizedStringKey("grades_title")
        static let current = LocalizedStringKey("grades_current_tab")
        static let session = LocalizedStringKey("grades_session_tab")
    }

    enum Profile {
        static let title = LocalizedStringKey("profile_title")
        static let loading = LocalizedStringKey("loading")
        static let group = LocalizedStringKey("group")
        static let personalNumber = LocalizedStringKey("personal_number")
        static let appTheme = LocalizedStringKey("app_theme")
        static let appLanguage = LocalizedStringKey("app_language")
        static let logout = LocalizedStringKey("logout")

        static let supportService = LocalizedStringKey("support_service")
        static let phone = LocalizedStringKey("phone")
        static let email = LocalizedStringKey("email")

        static let deleteAvatarTitle = LocalizedStringKey("delete_avatar_title")
        static let deleteAvatarMessage = LocalizedStringKey("delete_avatar_message")
        static let cancel = LocalizedStringKey("cancel")
        static let delete = LocalizedStringKey("delete")

        static let themeSystem = LocalizedStringKey("theme_system")
        static let themeLight = LocalizedStringKey("theme_light")
        static let themeDark = LocalizedStringKey("theme_dark")

        static let languageRussian = LocalizedStringKey("language_russian")
        static let languageEnglish = LocalizedStringKey("language_english")
        static let languageChinese = LocalizedStringKey("language_chinese")
    }

    enum Login {
        static let title = LocalizedStringKey("login_title")

        static let emailLabel = LocalizedStringKey("login_email_label")
        static let emailPlaceholder = LocalizedStringKey("login_email_placeholder")

        static let passwordLabel = LocalizedStringKey("login_password_label")
        static let passwordPlaceholder = LocalizedStringKey("login_password_placeholder")

        static let forgotPassword = LocalizedStringKey("login_forgot_password")

        static let loginButton = LocalizedStringKey("login_button")
        static let loginButtonLoading = LocalizedStringKey("login_button_loading")

        static let noAccount = LocalizedStringKey("login_no_account")
        static let createAccount = LocalizedStringKey("login_create_account")

        static let invalidEmail = LocalizedStringKey("login_error_invalid_email")
        static let passwordLength = LocalizedStringKey("login_error_password_length")
        static let invalidCredentials = LocalizedStringKey("login_error_invalid_credentials")
        static let networkError = LocalizedStringKey("login_error_network")
    }

    enum Welcome {
        static let title = LocalizedStringKey("welcome_title")
        static let continueButton = LocalizedStringKey("welcome_continue_button")
    }
    
    enum Register {
        static let title = LocalizedStringKey("register_title")
        static let description = LocalizedStringKey("register_description")
        static let backButton = LocalizedStringKey("register_back_button")
    }

    enum ForgotPassword {
        static let title = LocalizedStringKey("forgot_password_title")
        static let description = LocalizedStringKey("forgot_password_description")
        static let backButton = LocalizedStringKey("forgot_password_back_button")
    }

    enum TabBar {
        static let route = LocalizedStringKey("tab_route_title")
        static let home = LocalizedStringKey("tab_home_title")
        static let schedule = LocalizedStringKey("tab_schedule_title")
        static let grades = LocalizedStringKey("tab_grades_title")
        static let account = LocalizedStringKey("tab_account_title")
    }

    enum Map {
        static let title = LocalizedStringKey("map_title")
        static let goButton = LocalizedStringKey("map_go_button")
        static let fromPlaceholder = LocalizedStringKey("map_from_placeholder")
        static let toPlaceholder = LocalizedStringKey("map_to_placeholder")
        static let buildRouteButton = LocalizedStringKey("map_build_route_button")
        static let loadingData = LocalizedStringKey("map_loading_data")
    }
    
    enum QR {
        static let upload = LocalizedStringKey("qr_upload")
        static let change = LocalizedStringKey("qr_change")
        static let delete = LocalizedStringKey("qr_delete")

        static let selectSource = LocalizedStringKey("qr_select_source")
        static let takePhoto = LocalizedStringKey("qr_take_photo")
        static let chooseFromGallery = LocalizedStringKey("qr_choose_gallery")

        static let placeholderTitle = LocalizedStringKey("qr_placeholder_title")
        static let placeholderDescription = LocalizedStringKey("qr_placeholder_description")

        static let deleteAlertTitle = LocalizedStringKey("qr_delete_alert_title")
        static let deleteAlertMessage = LocalizedStringKey("qr_delete_alert_message")
    }

}

