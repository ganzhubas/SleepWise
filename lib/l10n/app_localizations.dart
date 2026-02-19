import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ru.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of L
/// returned by `L.of(context)`.
///
/// Applications need to include `L.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: L.localizationsDelegates,
///   supportedLocales: L.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the L.supportedLocales
/// property.
abstract class L {
  L(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static L of(BuildContext context) {
    return Localizations.of<L>(context, L)!;
  }

  static const LocalizationsDelegate<L> delegate = _LDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ru'),
  ];

  /// No description provided for @appName.
  ///
  /// In ru, this message translates to:
  /// **'SleepWise'**
  String get appName;

  /// No description provided for @skip.
  ///
  /// In ru, this message translates to:
  /// **'Пропустить'**
  String get skip;

  /// No description provided for @cancel.
  ///
  /// In ru, this message translates to:
  /// **'Отмена'**
  String get cancel;

  /// No description provided for @done.
  ///
  /// In ru, this message translates to:
  /// **'Готово'**
  String get done;

  /// No description provided for @allow.
  ///
  /// In ru, this message translates to:
  /// **'Разрешить'**
  String get allow;

  /// No description provided for @openSettings.
  ///
  /// In ru, this message translates to:
  /// **'Открыть настройки'**
  String get openSettings;

  /// No description provided for @notNow.
  ///
  /// In ru, this message translates to:
  /// **'Не сейчас'**
  String get notNow;

  /// No description provided for @later.
  ///
  /// In ru, this message translates to:
  /// **'Позже'**
  String get later;

  /// No description provided for @understood.
  ///
  /// In ru, this message translates to:
  /// **'Понятно'**
  String get understood;

  /// No description provided for @start.
  ///
  /// In ru, this message translates to:
  /// **'Начать'**
  String get start;

  /// No description provided for @onboardingTitle1.
  ///
  /// In ru, this message translates to:
  /// **'Просыпайтесь легко'**
  String get onboardingTitle1;

  /// No description provided for @onboardingSubtitle1.
  ///
  /// In ru, this message translates to:
  /// **'SleepWise анализирует ваш сон\nи будит в идеальный момент'**
  String get onboardingSubtitle1;

  /// No description provided for @onboardingTitle2.
  ///
  /// In ru, this message translates to:
  /// **'Просто положите\nтелефон рядом'**
  String get onboardingTitle2;

  /// No description provided for @onboardingSubtitle2.
  ///
  /// In ru, this message translates to:
  /// **'Микрофон определит фазы сна\nпо звукам движения'**
  String get onboardingSubtitle2;

  /// No description provided for @onboardingTitle3.
  ///
  /// In ru, this message translates to:
  /// **'Ваш сон в деталях'**
  String get onboardingTitle3;

  /// No description provided for @onboardingSubtitle3.
  ///
  /// In ru, this message translates to:
  /// **'Понятные графики и оценка\nкаждое утро'**
  String get onboardingSubtitle3;

  /// No description provided for @onboardingTitle4.
  ///
  /// In ru, this message translates to:
  /// **'Всё готово!'**
  String get onboardingTitle4;

  /// No description provided for @onboardingSubtitle4.
  ///
  /// In ru, this message translates to:
  /// **'Настройте будильник и ложитесь\nспать спокойно'**
  String get onboardingSubtitle4;

  /// No description provided for @onboardingDisclaimer.
  ///
  /// In ru, this message translates to:
  /// **'Приложение попросит доступ к микрофону\nи уведомлениям'**
  String get onboardingDisclaimer;

  /// No description provided for @permMicTitle.
  ///
  /// In ru, this message translates to:
  /// **'Доступ к микрофону'**
  String get permMicTitle;

  /// No description provided for @permMicAllowed.
  ///
  /// In ru, this message translates to:
  /// **'SleepWise слушает только звуки движения\nдля анализа фаз сна. Аудио не записывается.'**
  String get permMicAllowed;

  /// No description provided for @permMicDenied.
  ///
  /// In ru, this message translates to:
  /// **'Без микрофона анализ сна невозможен.\nВы можете разрешить доступ в настройках.'**
  String get permMicDenied;

  /// No description provided for @permPrivacy.
  ///
  /// In ru, this message translates to:
  /// **'Подробнее о приватности'**
  String get permPrivacy;

  /// No description provided for @permNotifTitle.
  ///
  /// In ru, this message translates to:
  /// **'Уведомления'**
  String get permNotifTitle;

  /// No description provided for @permNotifAllowed.
  ///
  /// In ru, this message translates to:
  /// **'Чтобы будильник точно сработал,\nдаже если приложение свёрнуто'**
  String get permNotifAllowed;

  /// No description provided for @permNotifDenied.
  ///
  /// In ru, this message translates to:
  /// **'Будильник может не сработать без уведомлений.\nВы можете включить их в настройках.'**
  String get permNotifDenied;

  /// No description provided for @greetingMorning.
  ///
  /// In ru, this message translates to:
  /// **'Доброе утро'**
  String get greetingMorning;

  /// No description provided for @greetingDay.
  ///
  /// In ru, this message translates to:
  /// **'Добрый день'**
  String get greetingDay;

  /// No description provided for @greetingEvening.
  ///
  /// In ru, this message translates to:
  /// **'Добрый вечер'**
  String get greetingEvening;

  /// No description provided for @greetingNight.
  ///
  /// In ru, this message translates to:
  /// **'Доброй ночи'**
  String get greetingNight;

  /// No description provided for @alarmInMinutes.
  ///
  /// In ru, this message translates to:
  /// **'Будильник через {minutes} мин'**
  String alarmInMinutes(int minutes);

  /// No description provided for @alarmInHours.
  ///
  /// In ru, this message translates to:
  /// **'Будильник через {hours} ч'**
  String alarmInHours(int hours);

  /// No description provided for @alarmInHoursMinutes.
  ///
  /// In ru, this message translates to:
  /// **'Будильник через {hours} ч {minutes} мин'**
  String alarmInHoursMinutes(int hours, int minutes);

  /// No description provided for @alarmBetween.
  ///
  /// In ru, this message translates to:
  /// **'Будильник сработает между {start} и {end}'**
  String alarmBetween(String start, String end);

  /// No description provided for @wakeWindowLabel.
  ///
  /// In ru, this message translates to:
  /// **'Окно пробуждения: {minutes} мин'**
  String wakeWindowLabel(int minutes);

  /// No description provided for @alarmTimeTitle.
  ///
  /// In ru, this message translates to:
  /// **'Время будильника'**
  String get alarmTimeTitle;

  /// No description provided for @activitySilence.
  ///
  /// In ru, this message translates to:
  /// **'ТИШИНА'**
  String get activitySilence;

  /// No description provided for @activityLightSleep.
  ///
  /// In ru, this message translates to:
  /// **'ЛЁГКИЙ СОН'**
  String get activityLightSleep;

  /// No description provided for @activityMedium.
  ///
  /// In ru, this message translates to:
  /// **'АКТИВНОСТЬ'**
  String get activityMedium;

  /// No description provided for @activityAwake.
  ///
  /// In ru, this message translates to:
  /// **'БОДРСТВОВАНИЕ'**
  String get activityAwake;

  /// No description provided for @activitySnoring.
  ///
  /// In ru, this message translates to:
  /// **'ХРАП'**
  String get activitySnoring;

  /// No description provided for @sleepTracking.
  ///
  /// In ru, this message translates to:
  /// **'Отслеживание сна'**
  String get sleepTracking;

  /// No description provided for @alarmRange.
  ///
  /// In ru, this message translates to:
  /// **'Будильник: {start} – {end}'**
  String alarmRange(String start, String end);

  /// No description provided for @battery.
  ///
  /// In ru, this message translates to:
  /// **'Батарея: {percent}%'**
  String battery(int percent);

  /// No description provided for @stopTrackingTitle.
  ///
  /// In ru, this message translates to:
  /// **'Остановить отслеживание?'**
  String get stopTrackingTitle;

  /// No description provided for @stopTrackingSubtitle.
  ///
  /// In ru, this message translates to:
  /// **'Данные сна будут сохранены'**
  String get stopTrackingSubtitle;

  /// No description provided for @stopButton.
  ///
  /// In ru, this message translates to:
  /// **'Остановить'**
  String get stopButton;

  /// No description provided for @continueButton.
  ///
  /// In ru, this message translates to:
  /// **'Продолжить'**
  String get continueButton;

  /// No description provided for @goodMorning.
  ///
  /// In ru, this message translates to:
  /// **'Доброе утро!'**
  String get goodMorning;

  /// No description provided for @snoozeButton.
  ///
  /// In ru, this message translates to:
  /// **'Отложить на 5 мин'**
  String get snoozeButton;

  /// No description provided for @snoozeRemaining.
  ///
  /// In ru, this message translates to:
  /// **'Осталось {remaining} из {total}'**
  String snoozeRemaining(int remaining, int total);

  /// No description provided for @noSnoozeLeft.
  ///
  /// In ru, this message translates to:
  /// **'Откладываний больше нет'**
  String get noSnoozeLeft;

  /// No description provided for @sleepDurationFormat.
  ///
  /// In ru, this message translates to:
  /// **'{hours}ч {minutes}мин'**
  String sleepDurationFormat(int hours, int minutes);

  /// No description provided for @sleepTimeLabel.
  ///
  /// In ru, this message translates to:
  /// **'Время сна'**
  String get sleepTimeLabel;

  /// No description provided for @fellAsleep.
  ///
  /// In ru, this message translates to:
  /// **'Заснул'**
  String get fellAsleep;

  /// No description provided for @wokeUp.
  ///
  /// In ru, this message translates to:
  /// **'Проснулся'**
  String get wokeUp;

  /// No description provided for @inBed.
  ///
  /// In ru, this message translates to:
  /// **'В кровати'**
  String get inBed;

  /// No description provided for @awakenings.
  ///
  /// In ru, this message translates to:
  /// **'Пробуждений'**
  String get awakenings;

  /// No description provided for @hypnogram.
  ///
  /// In ru, this message translates to:
  /// **'Гипнограмма'**
  String get hypnogram;

  /// No description provided for @snore.
  ///
  /// In ru, this message translates to:
  /// **'Храп'**
  String get snore;

  /// No description provided for @ofNight.
  ///
  /// In ru, this message translates to:
  /// **'ночи'**
  String get ofNight;

  /// No description provided for @scoreExcellent.
  ///
  /// In ru, this message translates to:
  /// **'Отличный сон'**
  String get scoreExcellent;

  /// No description provided for @scoreGood.
  ///
  /// In ru, this message translates to:
  /// **'Хороший сон'**
  String get scoreGood;

  /// No description provided for @scoreAverage.
  ///
  /// In ru, this message translates to:
  /// **'Средний сон'**
  String get scoreAverage;

  /// No description provided for @scorePoor.
  ///
  /// In ru, this message translates to:
  /// **'Плохой сон'**
  String get scorePoor;

  /// No description provided for @stageDeep.
  ///
  /// In ru, this message translates to:
  /// **'Глубокий'**
  String get stageDeep;

  /// No description provided for @stageLight.
  ///
  /// In ru, this message translates to:
  /// **'Лёгкий'**
  String get stageLight;

  /// No description provided for @stageRem.
  ///
  /// In ru, this message translates to:
  /// **'REM'**
  String get stageRem;

  /// No description provided for @stageAwake.
  ///
  /// In ru, this message translates to:
  /// **'Бодрств.'**
  String get stageAwake;

  /// No description provided for @recommendationExcellent.
  ///
  /// In ru, this message translates to:
  /// **'Отличная ночь! Вы заснули быстро и спали стабильно. Попробуйте ложиться в это же время каждый день для стабильного режима.'**
  String get recommendationExcellent;

  /// No description provided for @recommendationGood.
  ///
  /// In ru, this message translates to:
  /// **'Неплохой сон, но есть куда расти. Попробуйте ложиться на 30 минут раньше и уменьшить экранное время перед сном.'**
  String get recommendationGood;

  /// No description provided for @recommendationPoor.
  ///
  /// In ru, this message translates to:
  /// **'Этой ночью сон мог быть лучше. Обратите внимание на режим дня, избегайте кофеина после 16:00 и создайте комфортные условия.'**
  String get recommendationPoor;

  /// No description provided for @statistics.
  ///
  /// In ru, this message translates to:
  /// **'Статистика'**
  String get statistics;

  /// No description provided for @period7days.
  ///
  /// In ru, this message translates to:
  /// **'7 дней'**
  String get period7days;

  /// No description provided for @period30days.
  ///
  /// In ru, this message translates to:
  /// **'30 дней'**
  String get period30days;

  /// No description provided for @period3months.
  ///
  /// In ru, this message translates to:
  /// **'3 мес'**
  String get period3months;

  /// No description provided for @avgSleepTime.
  ///
  /// In ru, this message translates to:
  /// **'Среднее время сна'**
  String get avgSleepTime;

  /// No description provided for @avgBedtime.
  ///
  /// In ru, this message translates to:
  /// **'Среднее засыпание'**
  String get avgBedtime;

  /// No description provided for @bestDay.
  ///
  /// In ru, this message translates to:
  /// **'Лучший день'**
  String get bestDay;

  /// No description provided for @snoreAvg.
  ///
  /// In ru, this message translates to:
  /// **'{percent}% в среднем'**
  String snoreAvg(int percent);

  /// No description provided for @weekdayShortMon.
  ///
  /// In ru, this message translates to:
  /// **'Пн'**
  String get weekdayShortMon;

  /// No description provided for @weekdayShortTue.
  ///
  /// In ru, this message translates to:
  /// **'Вт'**
  String get weekdayShortTue;

  /// No description provided for @weekdayShortWed.
  ///
  /// In ru, this message translates to:
  /// **'Ср'**
  String get weekdayShortWed;

  /// No description provided for @weekdayShortThu.
  ///
  /// In ru, this message translates to:
  /// **'Чт'**
  String get weekdayShortThu;

  /// No description provided for @weekdayShortFri.
  ///
  /// In ru, this message translates to:
  /// **'Пт'**
  String get weekdayShortFri;

  /// No description provided for @weekdayShortSat.
  ///
  /// In ru, this message translates to:
  /// **'Сб'**
  String get weekdayShortSat;

  /// No description provided for @weekdayShortSun.
  ///
  /// In ru, this message translates to:
  /// **'Вс'**
  String get weekdayShortSun;

  /// No description provided for @weekdayMon.
  ///
  /// In ru, this message translates to:
  /// **'Понедельник'**
  String get weekdayMon;

  /// No description provided for @weekdayTue.
  ///
  /// In ru, this message translates to:
  /// **'Вторник'**
  String get weekdayTue;

  /// No description provided for @weekdayWed.
  ///
  /// In ru, this message translates to:
  /// **'Среда'**
  String get weekdayWed;

  /// No description provided for @weekdayThu.
  ///
  /// In ru, this message translates to:
  /// **'Четверг'**
  String get weekdayThu;

  /// No description provided for @weekdayFri.
  ///
  /// In ru, this message translates to:
  /// **'Пятница'**
  String get weekdayFri;

  /// No description provided for @weekdaySat.
  ///
  /// In ru, this message translates to:
  /// **'Суббота'**
  String get weekdaySat;

  /// No description provided for @weekdaySun.
  ///
  /// In ru, this message translates to:
  /// **'Воскресенье'**
  String get weekdaySun;

  /// No description provided for @settings.
  ///
  /// In ru, this message translates to:
  /// **'Настройки'**
  String get settings;

  /// No description provided for @settingsAlarm.
  ///
  /// In ru, this message translates to:
  /// **'Будильник'**
  String get settingsAlarm;

  /// No description provided for @settingsMelody.
  ///
  /// In ru, this message translates to:
  /// **'Мелодия будильника'**
  String get settingsMelody;

  /// No description provided for @settingsVolume.
  ///
  /// In ru, this message translates to:
  /// **'Громкость'**
  String get settingsVolume;

  /// No description provided for @settingsWakeWindow.
  ///
  /// In ru, this message translates to:
  /// **'Окно пробуждения'**
  String get settingsWakeWindow;

  /// No description provided for @settingsSnooze.
  ///
  /// In ru, this message translates to:
  /// **'Snooze'**
  String get settingsSnooze;

  /// No description provided for @settingsSnoozeDesc.
  ///
  /// In ru, this message translates to:
  /// **'5 мин, макс 3 раза'**
  String get settingsSnoozeDesc;

  /// No description provided for @settingsTracking.
  ///
  /// In ru, this message translates to:
  /// **'Отслеживание'**
  String get settingsTracking;

  /// No description provided for @settingsSensitivity.
  ///
  /// In ru, this message translates to:
  /// **'Чувствительность'**
  String get settingsSensitivity;

  /// No description provided for @settingsReminder.
  ///
  /// In ru, this message translates to:
  /// **'Напоминание'**
  String get settingsReminder;

  /// No description provided for @settingsIntegrations.
  ///
  /// In ru, this message translates to:
  /// **'Интеграции'**
  String get settingsIntegrations;

  /// No description provided for @settingsAppearance.
  ///
  /// In ru, this message translates to:
  /// **'Оформление'**
  String get settingsAppearance;

  /// No description provided for @settingsTheme.
  ///
  /// In ru, this message translates to:
  /// **'Тема'**
  String get settingsTheme;

  /// No description provided for @themeDark.
  ///
  /// In ru, this message translates to:
  /// **'Тёмная'**
  String get themeDark;

  /// No description provided for @themeLight.
  ///
  /// In ru, this message translates to:
  /// **'Светлая'**
  String get themeLight;

  /// No description provided for @themeAuto.
  ///
  /// In ru, this message translates to:
  /// **'Авто'**
  String get themeAuto;

  /// No description provided for @settingsLanguage.
  ///
  /// In ru, this message translates to:
  /// **'Язык'**
  String get settingsLanguage;

  /// No description provided for @langRu.
  ///
  /// In ru, this message translates to:
  /// **'Рус'**
  String get langRu;

  /// No description provided for @langEn.
  ///
  /// In ru, this message translates to:
  /// **'Eng'**
  String get langEn;

  /// No description provided for @settingsAccount.
  ///
  /// In ru, this message translates to:
  /// **'Аккаунт'**
  String get settingsAccount;

  /// No description provided for @restorePurchases.
  ///
  /// In ru, this message translates to:
  /// **'Восстановить покупки'**
  String get restorePurchases;

  /// No description provided for @settingsAbout.
  ///
  /// In ru, this message translates to:
  /// **'О приложении'**
  String get settingsAbout;

  /// No description provided for @privacyPolicy.
  ///
  /// In ru, this message translates to:
  /// **'Политика конфиденциальности'**
  String get privacyPolicy;

  /// No description provided for @termsOfUse.
  ///
  /// In ru, this message translates to:
  /// **'Условия использования'**
  String get termsOfUse;

  /// No description provided for @rateApp.
  ///
  /// In ru, this message translates to:
  /// **'Оценить приложение'**
  String get rateApp;

  /// No description provided for @version.
  ///
  /// In ru, this message translates to:
  /// **'Версия'**
  String get version;

  /// No description provided for @sensitivityLow.
  ///
  /// In ru, this message translates to:
  /// **'Low'**
  String get sensitivityLow;

  /// No description provided for @sensitivityMed.
  ///
  /// In ru, this message translates to:
  /// **'Med'**
  String get sensitivityMed;

  /// No description provided for @sensitivityHigh.
  ///
  /// In ru, this message translates to:
  /// **'High'**
  String get sensitivityHigh;

  /// No description provided for @healthNotConnected.
  ///
  /// In ru, this message translates to:
  /// **'Не подключено'**
  String get healthNotConnected;

  /// No description provided for @healthConnected.
  ///
  /// In ru, this message translates to:
  /// **'Подключено'**
  String get healthConnected;

  /// No description provided for @healthNoPermission.
  ///
  /// In ru, this message translates to:
  /// **'Нет разрешений'**
  String get healthNoPermission;

  /// No description provided for @healthDenied.
  ///
  /// In ru, this message translates to:
  /// **'Доступ отклонён'**
  String get healthDenied;

  /// No description provided for @healthUnavailable.
  ///
  /// In ru, this message translates to:
  /// **'Недоступно'**
  String get healthUnavailable;

  /// No description provided for @healthConnecting.
  ///
  /// In ru, this message translates to:
  /// **'Подключение...'**
  String get healthConnecting;

  /// No description provided for @healthViaConnect.
  ///
  /// In ru, this message translates to:
  /// **'Через Health Connect'**
  String get healthViaConnect;

  /// No description provided for @healthFailed.
  ///
  /// In ru, this message translates to:
  /// **'Не удалось подключить'**
  String get healthFailed;

  /// No description provided for @healthConnectNotFound.
  ///
  /// In ru, this message translates to:
  /// **'Health Connect не найден'**
  String get healthConnectNotFound;

  /// No description provided for @healthPermSnackbar.
  ///
  /// In ru, this message translates to:
  /// **'Разрешите доступ к {platform} в настройках устройства'**
  String healthPermSnackbar(String platform);

  /// No description provided for @healthUnavailableTitle.
  ///
  /// In ru, this message translates to:
  /// **'{name} недоступен'**
  String healthUnavailableTitle(String name);

  /// No description provided for @healthConnectInstall.
  ///
  /// In ru, this message translates to:
  /// **'Установите приложение Health Connect из Google Play для синхронизации данных о сне.'**
  String get healthConnectInstall;

  /// No description provided for @healthAppleCheck.
  ///
  /// In ru, this message translates to:
  /// **'Убедитесь, что приложение «Здоровье» доступно на вашем устройстве.'**
  String get healthAppleCheck;

  /// No description provided for @samsungHealthTitle.
  ///
  /// In ru, this message translates to:
  /// **'Samsung Health'**
  String get samsungHealthTitle;

  /// No description provided for @samsungHealthInstructions.
  ///
  /// In ru, this message translates to:
  /// **'На новых устройствах Samsung Health синхронизируется через Google Health Connect.\n\n1. Установите Health Connect из Google Play\n2. Откройте Samsung Health → Настройки → Health Connect\n3. Разрешите синхронизацию данных\n4. Вернитесь сюда и включите переключатель'**
  String get samsungHealthInstructions;

  /// No description provided for @sleepDataLabel.
  ///
  /// In ru, this message translates to:
  /// **'Данные сна'**
  String get sleepDataLabel;

  /// No description provided for @autoWrite.
  ///
  /// In ru, this message translates to:
  /// **'Автозапись'**
  String get autoWrite;

  /// No description provided for @off.
  ///
  /// In ru, this message translates to:
  /// **'Выкл'**
  String get off;

  /// No description provided for @minutesShort.
  ///
  /// In ru, this message translates to:
  /// **'{m} мин'**
  String minutesShort(int m);

  /// No description provided for @melodyVibration.
  ///
  /// In ru, this message translates to:
  /// **'Вибрация'**
  String get melodyVibration;

  /// No description provided for @paywallTitle.
  ///
  /// In ru, this message translates to:
  /// **'Раскройте весь\nпотенциал сна'**
  String get paywallTitle;

  /// No description provided for @paywallSubtitle.
  ///
  /// In ru, this message translates to:
  /// **'Всё для идеального сна в одном месте'**
  String get paywallSubtitle;

  /// No description provided for @paywallFeature1.
  ///
  /// In ru, this message translates to:
  /// **'Полная история сна без ограничений'**
  String get paywallFeature1;

  /// No description provided for @paywallFeature2.
  ///
  /// In ru, this message translates to:
  /// **'Расширенная аналитика и тренды'**
  String get paywallFeature2;

  /// No description provided for @paywallFeature3.
  ///
  /// In ru, this message translates to:
  /// **'Расписание по дням недели'**
  String get paywallFeature3;

  /// No description provided for @paywallFeature4.
  ///
  /// In ru, this message translates to:
  /// **'Детальный анализ храпа'**
  String get paywallFeature4;

  /// No description provided for @paywallFeature5.
  ///
  /// In ru, this message translates to:
  /// **'Дополнительные мелодии'**
  String get paywallFeature5;

  /// No description provided for @paywallFeature6.
  ///
  /// In ru, this message translates to:
  /// **'Экспорт данных'**
  String get paywallFeature6;

  /// No description provided for @paywallFeature7.
  ///
  /// In ru, this message translates to:
  /// **'Без рекламы'**
  String get paywallFeature7;

  /// No description provided for @planMonthly.
  ///
  /// In ru, this message translates to:
  /// **'Месячная'**
  String get planMonthly;

  /// No description provided for @planMonthlyPrice.
  ///
  /// In ru, this message translates to:
  /// **'99 ₽/мес'**
  String get planMonthlyPrice;

  /// No description provided for @planYearly.
  ///
  /// In ru, this message translates to:
  /// **'Годовая'**
  String get planYearly;

  /// No description provided for @planYearlyPrice.
  ///
  /// In ru, this message translates to:
  /// **'649 ₽/год'**
  String get planYearlyPrice;

  /// No description provided for @planYearlyBadge.
  ///
  /// In ru, this message translates to:
  /// **'−45%'**
  String get planYearlyBadge;

  /// No description provided for @finePrintYearly.
  ///
  /// In ru, this message translates to:
  /// **'Затем 649 ₽/год. Отмена в любое время.'**
  String get finePrintYearly;

  /// No description provided for @finePrintMonthly.
  ///
  /// In ru, this message translates to:
  /// **'Затем 99 ₽/мес. Отмена в любое время.'**
  String get finePrintMonthly;

  /// No description provided for @tryFree.
  ///
  /// In ru, this message translates to:
  /// **'Попробовать 7 дней бесплатно'**
  String get tryFree;

  /// No description provided for @tryFreeBanner.
  ///
  /// In ru, this message translates to:
  /// **'Попробовать бесплатно'**
  String get tryFreeBanner;

  /// No description provided for @proBannerFeature1.
  ///
  /// In ru, this message translates to:
  /// **'Подробная аналитика сна'**
  String get proBannerFeature1;

  /// No description provided for @proBannerFeature2.
  ///
  /// In ru, this message translates to:
  /// **'Умный будильник с ИИ'**
  String get proBannerFeature2;

  /// No description provided for @proBannerFeature3.
  ///
  /// In ru, this message translates to:
  /// **'Неограниченная история'**
  String get proBannerFeature3;

  /// No description provided for @proBannerFeature4.
  ///
  /// In ru, this message translates to:
  /// **'Экспорт данных'**
  String get proBannerFeature4;

  /// No description provided for @proBannerFeature5.
  ///
  /// In ru, this message translates to:
  /// **'Без рекламы'**
  String get proBannerFeature5;

  /// No description provided for @batteryOptTitle.
  ///
  /// In ru, this message translates to:
  /// **'Оптимизация батареи'**
  String get batteryOptTitle;

  /// No description provided for @batteryOptMessage.
  ///
  /// In ru, this message translates to:
  /// **'Устройства {brand} могут завершать работу приложений в фоновом режиме.\n\nДля надёжной работы будильника отключите оптимизацию батареи для SleepWise в настройках устройства.\n\nПодробнее: dontkillmyapp.com'**
  String batteryOptMessage(String brand);

  /// No description provided for @batteryManualInstructions.
  ///
  /// In ru, this message translates to:
  /// **'Откройте Настройки → Батарея → SleepWise → Без ограничений'**
  String get batteryManualInstructions;

  /// No description provided for @notifAlarmChannel.
  ///
  /// In ru, this message translates to:
  /// **'Будильник'**
  String get notifAlarmChannel;

  /// No description provided for @notifAlarmDesc.
  ///
  /// In ru, this message translates to:
  /// **'Будильник SleepWise — страховочное уведомление'**
  String get notifAlarmDesc;

  /// No description provided for @notifReminderChannel.
  ///
  /// In ru, this message translates to:
  /// **'Напоминания'**
  String get notifReminderChannel;

  /// No description provided for @notifReminderDesc.
  ///
  /// In ru, this message translates to:
  /// **'Напоминание ложиться спать'**
  String get notifReminderDesc;

  /// No description provided for @notifAlarmTitle.
  ///
  /// In ru, this message translates to:
  /// **'Пора просыпаться!'**
  String get notifAlarmTitle;

  /// No description provided for @notifAlarmBody.
  ///
  /// In ru, this message translates to:
  /// **'Ваш будильник SleepWise сработал'**
  String get notifAlarmBody;

  /// No description provided for @notifReminderTitle.
  ///
  /// In ru, this message translates to:
  /// **'Пора готовиться ко сну'**
  String get notifReminderTitle;

  /// No description provided for @notifReminderBody.
  ///
  /// In ru, this message translates to:
  /// **'Установите будильник в SleepWise'**
  String get notifReminderBody;

  /// No description provided for @notifSetAlarmAction.
  ///
  /// In ru, this message translates to:
  /// **'Установить будильник'**
  String get notifSetAlarmAction;

  /// No description provided for @tabAlarm.
  ///
  /// In ru, this message translates to:
  /// **'Будильник'**
  String get tabAlarm;

  /// No description provided for @tabStatistics.
  ///
  /// In ru, this message translates to:
  /// **'Статистика'**
  String get tabStatistics;

  /// No description provided for @tabSettings.
  ///
  /// In ru, this message translates to:
  /// **'Настройки'**
  String get tabSettings;
}

class _LDelegate extends LocalizationsDelegate<L> {
  const _LDelegate();

  @override
  Future<L> load(Locale locale) {
    return SynchronousFuture<L>(lookupL(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'ru'].contains(locale.languageCode);

  @override
  bool shouldReload(_LDelegate old) => false;
}

L lookupL(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return LEn();
    case 'ru':
      return LRu();
  }

  throw FlutterError(
    'L.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
