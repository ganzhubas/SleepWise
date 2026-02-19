// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class LRu extends L {
  LRu([String locale = 'ru']) : super(locale);

  @override
  String get appName => 'SleepWise';

  @override
  String get skip => 'Пропустить';

  @override
  String get cancel => 'Отмена';

  @override
  String get done => 'Готово';

  @override
  String get allow => 'Разрешить';

  @override
  String get openSettings => 'Открыть настройки';

  @override
  String get notNow => 'Не сейчас';

  @override
  String get later => 'Позже';

  @override
  String get understood => 'Понятно';

  @override
  String get start => 'Начать';

  @override
  String get onboardingTitle1 => 'Просыпайтесь легко';

  @override
  String get onboardingSubtitle1 =>
      'SleepWise анализирует ваш сон\nи будит в идеальный момент';

  @override
  String get onboardingTitle2 => 'Просто положите\nтелефон рядом';

  @override
  String get onboardingSubtitle2 =>
      'Микрофон определит фазы сна\nпо звукам движения';

  @override
  String get onboardingTitle3 => 'Ваш сон в деталях';

  @override
  String get onboardingSubtitle3 => 'Понятные графики и оценка\nкаждое утро';

  @override
  String get onboardingTitle4 => 'Всё готово!';

  @override
  String get onboardingSubtitle4 =>
      'Настройте будильник и ложитесь\nспать спокойно';

  @override
  String get onboardingDisclaimer =>
      'Приложение попросит доступ к микрофону\nи уведомлениям';

  @override
  String get permMicTitle => 'Доступ к микрофону';

  @override
  String get permMicAllowed =>
      'SleepWise слушает только звуки движения\nдля анализа фаз сна. Аудио не записывается.';

  @override
  String get permMicDenied =>
      'Без микрофона анализ сна невозможен.\nВы можете разрешить доступ в настройках.';

  @override
  String get permPrivacy => 'Подробнее о приватности';

  @override
  String get permNotifTitle => 'Уведомления';

  @override
  String get permNotifAllowed =>
      'Чтобы будильник точно сработал,\nдаже если приложение свёрнуто';

  @override
  String get permNotifDenied =>
      'Будильник может не сработать без уведомлений.\nВы можете включить их в настройках.';

  @override
  String get greetingMorning => 'Доброе утро';

  @override
  String get greetingDay => 'Добрый день';

  @override
  String get greetingEvening => 'Добрый вечер';

  @override
  String get greetingNight => 'Доброй ночи';

  @override
  String alarmInMinutes(int minutes) {
    return 'Будильник через $minutes мин';
  }

  @override
  String alarmInHours(int hours) {
    return 'Будильник через $hours ч';
  }

  @override
  String alarmInHoursMinutes(int hours, int minutes) {
    return 'Будильник через $hours ч $minutes мин';
  }

  @override
  String alarmBetween(String start, String end) {
    return 'Будильник сработает между $start и $end';
  }

  @override
  String wakeWindowLabel(int minutes) {
    return 'Окно пробуждения: $minutes мин';
  }

  @override
  String get alarmTimeTitle => 'Время будильника';

  @override
  String get activitySilence => 'ТИШИНА';

  @override
  String get activityLightSleep => 'ЛЁГКИЙ СОН';

  @override
  String get activityMedium => 'АКТИВНОСТЬ';

  @override
  String get activityAwake => 'БОДРСТВОВАНИЕ';

  @override
  String get activitySnoring => 'ХРАП';

  @override
  String get sleepTracking => 'Отслеживание сна';

  @override
  String alarmRange(String start, String end) {
    return 'Будильник: $start – $end';
  }

  @override
  String battery(int percent) {
    return 'Батарея: $percent%';
  }

  @override
  String get stopTrackingTitle => 'Остановить отслеживание?';

  @override
  String get stopTrackingSubtitle => 'Данные сна будут сохранены';

  @override
  String get stopButton => 'Остановить';

  @override
  String get continueButton => 'Продолжить';

  @override
  String get goodMorning => 'Доброе утро!';

  @override
  String get snoozeButton => 'Отложить на 5 мин';

  @override
  String snoozeRemaining(int remaining, int total) {
    return 'Осталось $remaining из $total';
  }

  @override
  String get noSnoozeLeft => 'Откладываний больше нет';

  @override
  String sleepDurationFormat(int hours, int minutes) {
    return '$hoursч $minutesмин';
  }

  @override
  String get sleepTimeLabel => 'Время сна';

  @override
  String get fellAsleep => 'Заснул';

  @override
  String get wokeUp => 'Проснулся';

  @override
  String get inBed => 'В кровати';

  @override
  String get awakenings => 'Пробуждений';

  @override
  String get hypnogram => 'Гипнограмма';

  @override
  String get snore => 'Храп';

  @override
  String get ofNight => 'ночи';

  @override
  String get scoreExcellent => 'Отличный сон';

  @override
  String get scoreGood => 'Хороший сон';

  @override
  String get scoreAverage => 'Средний сон';

  @override
  String get scorePoor => 'Плохой сон';

  @override
  String get stageDeep => 'Глубокий';

  @override
  String get stageLight => 'Лёгкий';

  @override
  String get stageRem => 'REM';

  @override
  String get stageAwake => 'Бодрств.';

  @override
  String get recommendationExcellent =>
      'Отличная ночь! Вы заснули быстро и спали стабильно. Попробуйте ложиться в это же время каждый день для стабильного режима.';

  @override
  String get recommendationGood =>
      'Неплохой сон, но есть куда расти. Попробуйте ложиться на 30 минут раньше и уменьшить экранное время перед сном.';

  @override
  String get recommendationPoor =>
      'Этой ночью сон мог быть лучше. Обратите внимание на режим дня, избегайте кофеина после 16:00 и создайте комфортные условия.';

  @override
  String get statistics => 'Статистика';

  @override
  String get period7days => '7 дней';

  @override
  String get period30days => '30 дней';

  @override
  String get period3months => '3 мес';

  @override
  String get avgSleepTime => 'Среднее время сна';

  @override
  String get avgBedtime => 'Среднее засыпание';

  @override
  String get bestDay => 'Лучший день';

  @override
  String snoreAvg(int percent) {
    return '$percent% в среднем';
  }

  @override
  String get weekdayShortMon => 'Пн';

  @override
  String get weekdayShortTue => 'Вт';

  @override
  String get weekdayShortWed => 'Ср';

  @override
  String get weekdayShortThu => 'Чт';

  @override
  String get weekdayShortFri => 'Пт';

  @override
  String get weekdayShortSat => 'Сб';

  @override
  String get weekdayShortSun => 'Вс';

  @override
  String get weekdayMon => 'Понедельник';

  @override
  String get weekdayTue => 'Вторник';

  @override
  String get weekdayWed => 'Среда';

  @override
  String get weekdayThu => 'Четверг';

  @override
  String get weekdayFri => 'Пятница';

  @override
  String get weekdaySat => 'Суббота';

  @override
  String get weekdaySun => 'Воскресенье';

  @override
  String get settings => 'Настройки';

  @override
  String get settingsAlarm => 'Будильник';

  @override
  String get settingsMelody => 'Мелодия будильника';

  @override
  String get settingsVolume => 'Громкость';

  @override
  String get settingsWakeWindow => 'Окно пробуждения';

  @override
  String get settingsSnooze => 'Snooze';

  @override
  String get settingsSnoozeDesc => '5 мин, макс 3 раза';

  @override
  String get settingsTracking => 'Отслеживание';

  @override
  String get settingsSensitivity => 'Чувствительность';

  @override
  String get settingsReminder => 'Напоминание';

  @override
  String get settingsIntegrations => 'Интеграции';

  @override
  String get settingsAppearance => 'Оформление';

  @override
  String get settingsTheme => 'Тема';

  @override
  String get themeDark => 'Тёмная';

  @override
  String get themeLight => 'Светлая';

  @override
  String get themeAuto => 'Авто';

  @override
  String get settingsLanguage => 'Язык';

  @override
  String get langRu => 'Рус';

  @override
  String get langEn => 'Eng';

  @override
  String get settingsAccount => 'Аккаунт';

  @override
  String get restorePurchases => 'Восстановить покупки';

  @override
  String get settingsAbout => 'О приложении';

  @override
  String get privacyPolicy => 'Политика конфиденциальности';

  @override
  String get termsOfUse => 'Условия использования';

  @override
  String get rateApp => 'Оценить приложение';

  @override
  String get version => 'Версия';

  @override
  String get sensitivityLow => 'Low';

  @override
  String get sensitivityMed => 'Med';

  @override
  String get sensitivityHigh => 'High';

  @override
  String get healthNotConnected => 'Не подключено';

  @override
  String get healthConnected => 'Подключено';

  @override
  String get healthNoPermission => 'Нет разрешений';

  @override
  String get healthDenied => 'Доступ отклонён';

  @override
  String get healthUnavailable => 'Недоступно';

  @override
  String get healthConnecting => 'Подключение...';

  @override
  String get healthViaConnect => 'Через Health Connect';

  @override
  String get healthFailed => 'Не удалось подключить';

  @override
  String get healthConnectNotFound => 'Health Connect не найден';

  @override
  String healthPermSnackbar(String platform) {
    return 'Разрешите доступ к $platform в настройках устройства';
  }

  @override
  String healthUnavailableTitle(String name) {
    return '$name недоступен';
  }

  @override
  String get healthConnectInstall =>
      'Установите приложение Health Connect из Google Play для синхронизации данных о сне.';

  @override
  String get healthAppleCheck =>
      'Убедитесь, что приложение «Здоровье» доступно на вашем устройстве.';

  @override
  String get samsungHealthTitle => 'Samsung Health';

  @override
  String get samsungHealthInstructions =>
      'На новых устройствах Samsung Health синхронизируется через Google Health Connect.\n\n1. Установите Health Connect из Google Play\n2. Откройте Samsung Health → Настройки → Health Connect\n3. Разрешите синхронизацию данных\n4. Вернитесь сюда и включите переключатель';

  @override
  String get sleepDataLabel => 'Данные сна';

  @override
  String get autoWrite => 'Автозапись';

  @override
  String get off => 'Выкл';

  @override
  String minutesShort(int m) {
    return '$m мин';
  }

  @override
  String get melodyVibration => 'Вибрация';

  @override
  String get paywallTitle => 'Раскройте весь\nпотенциал сна';

  @override
  String get paywallSubtitle => 'Всё для идеального сна в одном месте';

  @override
  String get paywallFeature1 => 'Полная история сна без ограничений';

  @override
  String get paywallFeature2 => 'Расширенная аналитика и тренды';

  @override
  String get paywallFeature3 => 'Расписание по дням недели';

  @override
  String get paywallFeature4 => 'Детальный анализ храпа';

  @override
  String get paywallFeature5 => 'Дополнительные мелодии';

  @override
  String get paywallFeature6 => 'Экспорт данных';

  @override
  String get paywallFeature7 => 'Без рекламы';

  @override
  String get planMonthly => 'Месячная';

  @override
  String get planMonthlyPrice => '99 ₽/мес';

  @override
  String get planYearly => 'Годовая';

  @override
  String get planYearlyPrice => '649 ₽/год';

  @override
  String get planYearlyBadge => '−45%';

  @override
  String get finePrintYearly => 'Затем 649 ₽/год. Отмена в любое время.';

  @override
  String get finePrintMonthly => 'Затем 99 ₽/мес. Отмена в любое время.';

  @override
  String get tryFree => 'Попробовать 7 дней бесплатно';

  @override
  String get tryFreeBanner => 'Попробовать бесплатно';

  @override
  String get proBannerFeature1 => 'Подробная аналитика сна';

  @override
  String get proBannerFeature2 => 'Умный будильник с ИИ';

  @override
  String get proBannerFeature3 => 'Неограниченная история';

  @override
  String get proBannerFeature4 => 'Экспорт данных';

  @override
  String get proBannerFeature5 => 'Без рекламы';

  @override
  String get batteryOptTitle => 'Оптимизация батареи';

  @override
  String batteryOptMessage(String brand) {
    return 'Устройства $brand могут завершать работу приложений в фоновом режиме.\n\nДля надёжной работы будильника отключите оптимизацию батареи для SleepWise в настройках устройства.\n\nПодробнее: dontkillmyapp.com';
  }

  @override
  String get batteryManualInstructions =>
      'Откройте Настройки → Батарея → SleepWise → Без ограничений';

  @override
  String get notifAlarmChannel => 'Будильник';

  @override
  String get notifAlarmDesc => 'Будильник SleepWise — страховочное уведомление';

  @override
  String get notifReminderChannel => 'Напоминания';

  @override
  String get notifReminderDesc => 'Напоминание ложиться спать';

  @override
  String get notifAlarmTitle => 'Пора просыпаться!';

  @override
  String get notifAlarmBody => 'Ваш будильник SleepWise сработал';

  @override
  String get notifReminderTitle => 'Пора готовиться ко сну';

  @override
  String get notifReminderBody => 'Установите будильник в SleepWise';

  @override
  String get notifSetAlarmAction => 'Установить будильник';

  @override
  String get tabAlarm => 'Будильник';

  @override
  String get tabStatistics => 'Статистика';

  @override
  String get tabSettings => 'Настройки';

  @override
  String get emptyStatsTitle => 'Пока нет данных';

  @override
  String get emptyStatsSubtitle =>
      'Установите первый будильник,\nчтобы увидеть статистику сна';

  @override
  String get emptyStatsButton => 'Установить будильник';

  @override
  String get noMicTitle => 'Нет доступа к микрофону';

  @override
  String get noMicSubtitle =>
      'Без микрофона анализ сна невозможен.\nРазрешите доступ в настройках устройства.';

  @override
  String get noMicButton => 'Открыть настройки';

  @override
  String get audioError => 'Ошибка звука — будильник сработает с вибрацией';

  @override
  String get lowBatteryTitle => 'Низкий заряд батареи';

  @override
  String lowBatteryMessage(int percent) {
    return 'Заряд батареи $percent%. Подключите зарядное устройство перед началом отслеживания сна для надёжной работы будильника.';
  }

  @override
  String get lowBatteryProceed => 'Всё равно начать';

  @override
  String get lowBatteryCharge => 'Поставить на зарядку';
}
