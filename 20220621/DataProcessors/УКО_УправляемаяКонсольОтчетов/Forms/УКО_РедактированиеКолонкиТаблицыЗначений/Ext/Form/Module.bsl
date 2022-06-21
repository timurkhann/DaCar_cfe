﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Режим = "Перечисление.УКО_РежимРедактированияКолонкиТаблицыЗначений.Добавление" Тогда
		ЗаголовокФормы = НСтр("ru = 'Добавление колонки'; en = 'Adding a column'");
	ИначеЕсли Параметры.Режим = "Перечисление.УКО_РежимРедактированияКолонкиТаблицыЗначений.Изменение" Тогда		
		ЗаголовокФормы = НСтр("ru = 'Редактирование колонки'; en = 'Editing a column'");;
	КонецЕсли;
	УКО_ФормыКлиентСервер_Заголовок(ЭтаФорма, ЗаголовокФормы);
	ОбъектОбработки().УКО_ПроверкаОшибокВФорме_Инициализировать(ЭтаФорма);

	Идентификатор = Параметры.Идентификатор;
	Тип = Параметры.ОписаниеТипов;
	Индексировать = Параметры.Индексировать;
	
	ЗанятыеИдентификаторы.ЗагрузитьЗначения(Параметры.ЗанятыеИдентификаторы);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ОбновитьЭлементыФормы();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ИдентификаторПриИзменении(Элемент)
	
	ПодключитьОбработчикОжидания("ПриИзмененииДанныхПослеОжидания", 0.1, Истина);	
	
КонецПроцедуры

&НаКлиенте
Процедура ТипПриИзменении(Элемент)
	
	ПодключитьОбработчикОжидания("ПриИзмененииДанныхПослеОжидания", 0.1, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ТипНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ОписаниеОповещенияЗавершение = Новый ОписаниеОповещения("ИзменениеТипаЗавершено", ЭтотОбъект, Новый Структура);
	
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("Заголовок", НСтр("ru = 'Колонка'; en = 'Column'"));
	УКО_ФормыКлиент_ОткрытьРедактированиеТипаЗначения(Элемент, "Перечисление.УКО_РежимРедактированияТипаЗначения.РедактированиеОписанияТипов",
														Тип, ОписаниеОповещенияЗавершение, ДополнительныеПараметры);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОшибкиОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	УКО_ПроверкаОшибокВФормеКлиент_ОбработкаНавигационнойСсылки(ЭтаФорма, Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОК(Команда)
	
	ОшибкиЗаполнения = ПроверкаЗаполнения();
	
	Если ЗначениеЗаполнено(ОшибкиЗаполнения) Тогда
		
		УКО_ПроверкаОшибокВФормеКлиент_ТекущийЭлементПоПервой(ЭтаФорма, ОшибкиЗаполнения);
		
	Иначе
		
		Результат = Новый Структура;
		Результат.Вставить("Имя", Идентификатор);
		Результат.Вставить("Тип", Тип);
		Результат.Вставить("Индексировать", Индексировать);
		
		Закрыть(Результат);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ОбновитьЭлементыФормы()
	
	УКО_ПроверкаОшибокВФормеКлиент_Обновить(ЭтаФорма, ПроверкаЗаполнения());
	
КонецПроцедуры
	
&НаКлиенте
Процедура ПриИзмененииДанныхПослеОжидания()

	ОбновитьЭлементыФормы();

КонецПроцедуры

&НаКлиенте
Функция ПроверкаЗаполнения()
	
	Результат = Новый СписокЗначений;
	
	ОшибкиИдентификатора = УКО_СтрокиКлиентСервер_ПроверкаИдентификатора(Идентификатор, ЗанятыеИдентификаторы.ВыгрузитьЗначения());	
	
	Для Каждого ОшибкаИдентификатора Из ОшибкиИдентификатора Цикл
		Результат.Добавить("Идентификатор", ОшибкаИдентификатора);
	КонецЦикла;
	
	Если Не ЗначениеЗаполнено(Тип) Тогда
		Результат.Добавить("Тип", НСтр("ru = 'Не заполнен тип'; en = 'Type not filled'"));
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

&НаКлиенте
Процедура ИзменениеТипаЗавершено(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Модифицированность = Истина;
	Тип = Результат;
	
	ПодключитьОбработчикОжидания("ПриИзмененииДанныхПослеОжидания", 0.1, Истина);

КонецПроцедуры


#КонецОбласти

&НаСервере
Функция ОбъектОбработки()
	Возврат РеквизитФормыВЗначение("Объект");
КонецФункции
&НаКлиентеНаСервереБезКонтекста
// Проверяет идентификатор
//
// Параметры:
//   Идентификатор - Строка - Идентификатор
//   ЗанятыеИдентификаторы - Массив - Занятые идентификаторы
//
// Возвращаемое значение:
//   Массив - Ошибки проверки
//
Функция УКО_СтрокиКлиентСервер_ПроверкаИдентификатора(Идентификатор, ЗанятыеИдентификаторы = Неопределено) Экспорт
	
	Ошибки = Новый Массив;
	
	Если ЗанятыеИдентификаторы = Неопределено Тогда
		ЗанятыеИдентификаторы = Новый Массив;
	КонецЕсли;
	
	КорректныйИдентификатор = УКО_СтрокиКлиентСервер_ЭтоКорректныйИдентификатор(Идентификатор);
	Если Не КорректныйИдентификатор Тогда
		Ошибки.Добавить(НСтр("ru = 'Неверное имя. Имя должно состоять из одного слова, начинаться с буквы или ""_""
                              |и не содержать специальных символов кроме ""_""';
							  |en = 'Invalid name. The name must consist of one word, begin with a letter or ""_""
                              |and do not contain special characters except ""_""'"));
	КонецЕсли;
	
	ИдентификаторИспользуется = (ЗанятыеИдентификаторы.Найти(Идентификатор) <> Неопределено);
	Если ИдентификаторИспользуется Тогда
		Ошибки.Добавить(НСтр("ru = 'Идентификатор используется'; en = 'ID used'"));
	КонецЕсли;
	
	Возврат Ошибки;
	
КонецФункции
&НаКлиентеНаСервереБезКонтекста
// Возвращает цвет текста важной гиперссылки
//
// Возвращаемое значение:
//   Цвет - Цвет текста
//
Функция УКО_ОбщегоНазначенияКлиентСервер_ЦветТекстаВажнойГиперссылки() Экспорт
	
	Возврат Новый Цвет(125,0,0); 
	
КонецФункции
&НаКлиентеНаСервереБезКонтекста
// Определяет, это режим запуска программы
//
// Возвращаемое значение:
//   Булево	- Истина, Режим запуска внешняя обработка
//
Функция УКО_ОбщегоНазначенияКлиентСервер_РежимЗапускаВнешняяОбработка() Экспорт
	
	Возврат Истина;
	
КонецФункции
&НаКлиенте
// Обновляет данные элементов ошибок
//
// Параметры:
//  Форма - Форма - Форма
//  Ошибки - СписокЗначение - Ошибки Значение - имя элемента, Представление - Текст ошибки
//
Процедура УКО_ПроверкаОшибокВФормеКлиент_Обновить(Форма, Ошибки) Экспорт
	
	Результат = Новый Массив;
	КоличествоСтрок = 0;
	Для Каждого Ошибка Из Ошибки Цикл 
		
		Если ЗначениеЗаполнено(Результат) Тогда
			Результат.Добавить(Символы.ПС);
		КонецЕсли;
		
		ТекстОшибки = Ошибка.Представление;
		КоличествоСтрок = КоличествоСтрок + СтрЧислоСтрок(ТекстОшибки);
		Результат.Добавить(Новый ФорматированнаяСтрока(ТекстОшибки,, УКО_ОбщегоНазначенияКлиентСервер_ЦветТекстаВажнойГиперссылки(),, Ошибка.Значение));
		
	КонецЦикла;
	
	ЭлементОшибки = Форма.Элементы.Ошибки;
	КоличествоОшибок = Ошибки.Количество();
	
	Если ЭлементОшибки.Высота < КоличествоСтрок Тогда
		ЭлементОшибки.Высота = КоличествоСтрок;
	КонецЕсли;

	Форма.Ошибки = Новый ФорматированнаяСтрока(Результат);
	
КонецПроцедуры
&НаКлиентеНаСервереБезКонтекста

Функция УКО_СтрокиКлиентСервер_НаборСимволовЛатинскиеБуквы()
	
	НаборСимволов = "QWERTYUIOPASDFGHJKLZXCVBNM";
	Возврат НаборСимволов + НРег(НаборСимволов);
	
КонецФункции
&НаКлиенте
// Обработчик события ОбработкаНавигационнойСсылки
//
// Параметры:
//  Форма - Форма - Форма
//  Элемент - Элемент - Элемент
//  НавигационнаяСсылкаФорматированнойСтроки - Строка - Текст навигационной ссылки
//  СтандартнаяОбработка - Булево - Признак стандартной обработки
//
Процедура УКО_ПроверкаОшибокВФормеКлиент_ОбработкаНавигационнойСсылки(Форма, Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка) Экспорт
	
	СтандартнаяОбработка = Ложь;
	Форма.ТекущийЭлемент = Форма.Элементы[НавигационнаяСсылкаФорматированнойСтроки];
	
КонецПроцедуры
&НаКлиентеНаСервереБезКонтекста
// Возвращает набор символов букв русского и английского языков
// Возвращаемое значение:
//   Строка - Набор символов букв
Функция УКО_СтрокиКлиентСервер_НаборСимволовРусскиеЛатинскиеБуквы()
	
	НаборСимволовРусскиеБуквы = "ЙЦУКЕ" + Символ(1025) + "НГШЩЗХЪФЫВАПРОЛДЖЭЯЧСМИТЬБЮ"; //1025 - Код символа буквы ежик, елка
	НаборСимволовРусскиеБуквы = НаборСимволовРусскиеБуквы + НРег(НаборСимволовРусскиеБуквы);
	
	Возврат НаборСимволовРусскиеБуквы + УКО_СтрокиКлиентСервер_НаборСимволовЛатинскиеБуквы();
	
КонецФункции
&НаКлиенте
// Устанавливает текущим первый элемент ошибки
//
// Параметры:
//  Форма - Форма - Форма
//  Ошибки - СписокЗначение - Ошибки Значение - имя элемента, Представление - Текст ошибки
//
Процедура УКО_ПроверкаОшибокВФормеКлиент_ТекущийЭлементПоПервой(Форма, Ошибки) Экспорт
	
	Форма.ТекущийЭлемент = Форма.Элементы[Ошибки[0].Значение];
	
КонецПроцедуры
&НаКлиентеНаСервереБезКонтекста
// Проверяет является ли строка корректным идентификатором, строка вида СуммаКонтрагента, _Идентификатор
//
// Параметры:
//   Строка - Строка - Проверяемая строка
//
// Возвращаемое значение:
//   Булево - Истина, идентификатор корректный
//
Функция УКО_СтрокиКлиентСервер_ЭтоКорректныйИдентификатор(Строка) Экспорт
	
	ПервыйСимволСимволы = УКО_СтрокиКлиентСервер_НаборСимволовРусскиеЛатинскиеБуквы() + "_";
	ПоследующиеСимволы = УКО_СтрокиКлиентСервер_НаборСимволовРусскиеЛатинскиеБуквы() + УКО_СтрокиКлиентСервер_НаборСимволовЦифры() + "_";
	 
	Если ПустаяСтрока(Строка) ИЛИ Не СтрНайти(ПервыйСимволСимволы, Лев(Строка, 1)) Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Для Сч = 2 По СтрДлина(Строка) Цикл 
		
		Символ = Сред(Строка, Сч, 1);
		
		Если Не СтрНайти(ПоследующиеСимволы, Символ) Тогда
			Возврат Ложь;
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат Истина;
	
КонецФункции
&НаКлиентеНаСервереБезКонтекста

Функция УКО_СтрокиКлиентСервер_НаборСимволовЦифры()
	
	Возврат "0123456789";
	
КонецФункции
&НаКлиентеНаСервереБезКонтекста
// Возвращает идентификатор расширения
// Возвращаемое значение:
//   Строка	- Идентификатор расширения
Функция УКО_ОбщегоНазначенияКлиентСервер_ИдентификаторРасширения() Экспорт 
	
	Возврат "УправляемаяКонсольОтчетов";
	
КонецФункции
&НаКлиенте
// Открывает форму редактирования типа значения
//
// Параметры:
//	Владелец - Форма/Элемент - Владелец
//	РежимРедактирования - Перечисление.УКО_РежимРедактированияТипаЗначения - Режим редактирования типа значения
//	Значение - Произвольный/ОписаниеТипов - Значение
//	ОписаниеОповещенияЗавершение - ОписаниеОповещения - Описание оповещения при завершении
//	ДополнительныеПараметры - Структура - Дополнительные параметры
//	 *Заголовок - Строка - Заголовок
//	 *ЗакрыватьПриВыборе - Булево - Закрывать при выборе
//	 *ИсключаемыеТипы - Строка - Исключаемые типы через запятую
//
Процедура УКО_ФормыКлиент_ОткрытьРедактированиеТипаЗначения(Владелец, РежимРедактирования, Значение, ОписаниеОповещенияЗавершение, ДополнительныеПараметры = Неопределено) Экспорт
	
	Если ДополнительныеПараметры = Неопределено Тогда
		ДополнительныеПараметры = Новый Структура;
	КонецЕсли;
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Значение", Значение);
	ПараметрыФормы.Вставить("Режим", РежимРедактирования);
	
	ПараметрыФормы.Вставить("Заголовок", УКО_ОбщегоНазначенияКлиентСервер_ЗначениеСвойстваСтруктуры(ДополнительныеПараметры, "Заголовок", ""));
	ПараметрыФормы.Вставить("ЗакрыватьПриВыборе", УКО_ОбщегоНазначенияКлиентСервер_ЗначениеСвойстваСтруктуры(ДополнительныеПараметры, "ЗакрыватьПриВыборе", Истина));
	ПараметрыФормы.Вставить("ИсключаемыеТипы", УКО_ОбщегоНазначенияКлиентСервер_ЗначениеСвойстваСтруктуры(ДополнительныеПараметры, "ИсключаемыеТипы", ""));
	
	ВыборТипа = (РежимРедактирования = "Перечисление.УКО_РежимРедактированияТипаЗначения.ВыборТипа");
	ОписаниеОповещенияЗавершение.ДополнительныеПараметры.Вставить("ВыборТипа", ВыборТипа);
	
	УКО_ФормыКлиент_ОткрытьДополнительную("РедактированиеТипаЗначения", ПараметрыФормы, Владелец,, ОписаниеОповещенияЗавершение);
	
КонецПроцедуры
&НаКлиентеНаСервереБезКонтекста
// Получает значение свойства структуры
// Параметры:
//   Структура - Структура - Структура
//   Имя - Строка - Имя свойства
//   ЗначениеПоУмолчанию - Произвольный - Значение по умолчанию, когда в данной структуре нет этого свойства
// Возвращаемое значение:
//   Произвольный - Значение свойства структуры
Функция УКО_ОбщегоНазначенияКлиентСервер_ЗначениеСвойстваСтруктуры(Структура = Неопределено, Имя = Неопределено, ЗначениеПоУмолчанию = Неопределено) Экспорт
	
	Значение = ЗначениеПоУмолчанию;
	
	Если (ТипЗнч(Структура) = Тип("Структура")
				ИЛИ ТипЗнч(Структура) = Тип("ДанныеФормыСтруктура"))
			И Структура.Свойство(Имя) Тогда
		
		Значение = Структура[Имя];
		
	КонецЕсли;
	
	Возврат Значение;
	
КонецФункции
&НаКлиенте
// Открывает дополнительную/вспомогательную форму
//
// Параметры:
//	Имя - Строка - Имя формы
//	Параметры - Структура - Параметры формы (необязательный)
//	Владелец - Форма - Форма владелец
//	Уникальность - Произвольный - Уникальность (необязательный)
//	ОписаниеОповещенияОЗакрытии - ОписаниеОповещения - Описание оповещения о закрытии (необязательный)
//
Процедура УКО_ФормыКлиент_ОткрытьДополнительную(Имя, Параметры = Неопределено, Владелец = Неопределено, Уникальность = Неопределено, ОписаниеОповещенияОЗакрытии = Неопределено) Экспорт
	
	Если УКО_ОбщегоНазначенияКлиентСервер_РежимЗапускаВнешняяОбработка() Тогда
		ОбъектФорм = СтрШаблон("ВнешняяОбработка.%1%2.Форма.", УКО_ОбщегоНазначенияКлиентСервер_ПрефиксРасширения(), УКО_ОбщегоНазначенияКлиентСервер_ИдентификаторРасширения());
	Иначе
		ОбъектФорм = "ОбщаяФорма";
	КонецЕсли;
	
	ПолноеИмяФормы = СтрШаблон("%1.%2%3", ОбъектФорм, УКО_ОбщегоНазначенияКлиентСервер_ПрефиксРасширения(), Имя);
	
	Если Владелец = Неопределено Тогда
		РежимОткрытия = Неопределено;
	Иначе 
		РежимОткрытия = РежимОткрытияОкнаФормы.БлокироватьОкноВладельца;
	КонецЕсли;
	
	ОткрытьФорму(ПолноеИмяФормы, Параметры, Владелец, Уникальность,,,ОписаниеОповещенияОЗакрытии, РежимОткрытия);
	
КонецПроцедуры
&НаКлиентеНаСервереБезКонтекста
// Возвращает префикс объектов расширения
// Возвращаемое значение:
//   Строка	- Префикс объектов расширения
Функция УКО_ОбщегоНазначенияКлиентСервер_ПрефиксРасширения() Экспорт 
	
	Возврат "УКО_";
	
КонецФункции
&НаКлиентеНаСервереБезКонтекста
// Обновляет заголовок формы
//
// Параметры:
//  Форма - Форма - Форма
//  Заголовок - Строка - Заголовок формы
//  Дополнение - Булево - Дополнять заголовок названием расширения
//
Процедура УКО_ФормыКлиентСервер_Заголовок(Форма, Заголовок, Дополнение = Ложь) Экспорт
	
	НовыйЗаголовок = Заголовок;
	
	Если Дополнение Тогда
		НовыйЗаголовок = НовыйЗаголовок + " : " + УКО_ОбщегоНазначенияКлиентСервер_ИмяРасширения();
	КонецЕсли;
	
	Форма.Заголовок = НовыйЗаголовок;
	
КонецПроцедуры
&НаКлиентеНаСервереБезКонтекста
// Возвращает имя расширения
// Возвращаемое значение:
//   Строка	- Имя расширения
Функция УКО_ОбщегоНазначенияКлиентСервер_ИмяРасширения() Экспорт 
	
	Возврат НСтр("ru = 'Управляемая консоль отчетов'; en = 'Managed reporting console'");
	
КонецФункции
