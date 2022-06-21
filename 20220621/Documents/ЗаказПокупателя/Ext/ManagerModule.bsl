﻿
&ИзменениеИКонтроль("СформироватьЗаказНаряд")
Процедура тм_СформироватьЗаказНаряд(ПечатнаяФорма, МассивОбъектов, ОбъектыПечати, Ошибки)
	Перем ПервыйДокумент, НомерСтрокиНачало;

	ТабличныйДокумент = ПечатнаяФорма.ТабличныйДокумент;
	Макет = УправлениеПечатью.МакетПечатнойФормы(ПечатнаяФорма.ПолныйПутьКМакету);
	ПредставлениеСкидки = Константы.ПредставлениеСкидкиВПечатнойФорме.Получить();

	ПечатьДокументовУНФ.ПередНачаломФормированияДокумента(ТабличныйДокумент, ПервыйДокумент, НомерСтрокиНачало);

	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("МассивОбъектов", МассивОбъектов);
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ЗаказПокупателя.Ссылка КАК Ссылка,
	|	ЗаказПокупателя.Номер КАК Номер,
	|	ЗаказПокупателя.Дата КАК ДатаДокумента,
	|	ЗаказПокупателя.Старт КАК Старт,
	|	ЗаказПокупателя.Финиш КАК Финиш,
	|	ЗаказПокупателя.Организация КАК Организация,
	|	ЗаказПокупателя.ПодписьРуководителя.РасшифровкаПодписи КАК РасшифровкаПодписиВыполнилРаботыУслуги,
	|	ЗаказПокупателя.Контрагент КАК Контрагент,
	|	ЗаказПокупателя.КонтактноеЛицоПодписант.Наименование КАК РасшифровкаПодписиПринялРаботыУслуги,
	|	ЗаказПокупателя.СуммаВключаетНДС КАК СуммаВключаетНДС,
	|	ЗаказПокупателя.ВалютаДокумента КАК ВалютаДокумента,
	|	ЗаказПокупателя.Организация.Префикс КАК Префикс,
	|	ЗаказПокупателя.Запасы.(
	|		НомерСтроки КАК НомерСтроки,
	|		ВЫБОР
	|			КОГДА (ВЫРАЗИТЬ(ЗаказПокупателя.Запасы.Номенклатура.НаименованиеПолное КАК СТРОКА(1000))) = """"
	|				ТОГДА ЗаказПокупателя.Запасы.Номенклатура.Наименование
	|			ИНАЧЕ ВЫРАЗИТЬ(ЗаказПокупателя.Запасы.Номенклатура.НаименованиеПолное КАК СТРОКА(1000))
	|		КОНЕЦ КАК Товар,
	|		Номенклатура.Артикул КАК Артикул,
	|		Номенклатура.Штрихкод КАК Штрихкод,
	|		ЕдиницаИзмерения.Наименование КАК ЕдиницаИзмерения,
	|		Количество КАК Количество,
	|		Цена КАК Цена,
	|		Сумма КАК Сумма,
	|		СуммаНДС КАК СуммаНДС,
	|		Всего КАК Всего,
	|		Характеристика КАК Характеристика,
	|		Содержание КАК Содержание,
	|		ПроцентСкидкиНаценки КАК ПроцентСкидкиНаценки,
	|		ВЫБОР
	|			КОГДА ЗаказПокупателя.Запасы.ПроцентСкидкиНаценки <> 0
	|					ИЛИ ЗаказПокупателя.Запасы.СуммаАвтоматическойСкидки <> 0
	|				ТОГДА 1
	|			ИНАЧЕ 0
	|		КОНЕЦ КАК ЕстьСкидка,
	|		СуммаАвтоматическойСкидки КАК СуммаАвтоматическойСкидки,
	|		КлючСвязи КАК КлючСвязи,
	|		ЛОЖЬ КАК ЭтоНабор,
	|		ВЫБОР
	|			КОГДА ЗаказПокупателя.Запасы.НоменклатураНабора <> ЗНАЧЕНИЕ(Справочник.Номенклатура.ПустаяСсылка)
	|					И ЗаказПокупателя.Запасы.НоменклатураНабора.ВариантПечатиНабора = ЗНАЧЕНИЕ(Перечисление.ВариантыПечатиНаборов.НаборИКомплектующие)
	|				ТОГДА ИСТИНА
	|			ИНАЧЕ ЛОЖЬ
	|		КОНЕЦ КАК НеобходимоВыделитьКакСоставНабора,
	|		НоменклатураНабора КАК НоменклатураНабора,
	|		ХарактеристикаНабора КАК ХарактеристикаНабора
	|	) КАК ТаблицаЗапасы,
	|	ЗаказПокупателя.Работы.(
	|		НомерСтроки КАК НомерСтроки,
	|		ВЫБОР
	|			КОГДА (ВЫРАЗИТЬ(ЗаказПокупателя.Работы.Номенклатура.НаименованиеПолное КАК СТРОКА(1000))) = """"
	|				ТОГДА ЗаказПокупателя.Работы.Номенклатура.Наименование
	|			ИНАЧЕ ВЫРАЗИТЬ(ЗаказПокупателя.Работы.Номенклатура.НаименованиеПолное КАК СТРОКА(1000))
	|		КОНЕЦ КАК Товар,
	|		Номенклатура.Артикул КАК Артикул,
	|		Номенклатура.Штрихкод КАК Штрихкод,
	|		Номенклатура.ЕдиницаИзмерения.Наименование КАК ЕдиницаИзмерения,
	|		ЗаказПокупателя.Работы.Количество * ЗаказПокупателя.Работы.Коэффициент * ЗаказПокупателя.Работы.Кратность КАК Количество,
	|		Цена КАК Цена,
	|		Сумма КАК Сумма,
	|		СуммаНДС КАК СуммаНДС,
	|		Всего КАК Всего,
	|		Характеристика КАК Характеристика,
	|		Содержание КАК Содержание,
	|		ПроцентСкидкиНаценки КАК ПроцентСкидкиНаценки,
	|		ВЫБОР
	|			КОГДА ЗаказПокупателя.Работы.ПроцентСкидкиНаценки <> 0
	|					ИЛИ ЗаказПокупателя.Работы.СуммаАвтоматическойСкидки <> 0
	|				ТОГДА 1
	|			ИНАЧЕ 0
	|		КОНЕЦ КАК ЕстьСкидка,
	|		КлючСвязи КАК КлючСвязи,
	|		СуммаАвтоматическойСкидки КАК СуммаАвтоматическойСкидки,
	|		ЛОЖЬ КАК ЭтоНабор,
	|		ВЫБОР
	|			КОГДА ЗаказПокупателя.Работы.НоменклатураНабора <> ЗНАЧЕНИЕ(Справочник.Номенклатура.ПустаяСсылка)
	|					И ЗаказПокупателя.Работы.НоменклатураНабора.ВариантПечатиНабора = ЗНАЧЕНИЕ(Перечисление.ВариантыПечатиНаборов.НаборИКомплектующие)
	|				ТОГДА ИСТИНА
	|			ИНАЧЕ ЛОЖЬ
	|		КОНЕЦ КАК НеобходимоВыделитьКакСоставНабора,
	|		НоменклатураНабора КАК НоменклатураНабора,
	|		ХарактеристикаНабора КАК ХарактеристикаНабора
	#Вставка
	|		,Представление(тм_СторонаУстановки) КАК СторонаУстановки
	#КонецВставки		
	|	) КАК ТаблицаРаботы,
	|	ЗаказПокупателя.МатериалыЗаказчика.(
	|		НомерСтроки КАК НомерСтроки,
	|		ВЫБОР
	|			КОГДА (ВЫРАЗИТЬ(ЗаказПокупателя.МатериалыЗаказчика.Номенклатура.НаименованиеПолное КАК СТРОКА(1000))) = """"
	|				ТОГДА ЗаказПокупателя.МатериалыЗаказчика.Номенклатура.Наименование
	|			ИНАЧЕ ВЫРАЗИТЬ(ЗаказПокупателя.МатериалыЗаказчика.Номенклатура.НаименованиеПолное КАК СТРОКА(1000))
	|		КОНЕЦ КАК Товар,
	|		Номенклатура.Артикул КАК Артикул,
	|		Номенклатура.Штрихкод КАК Штрихкод,
	|		ЕдиницаИзмерения.Наименование КАК ЕдиницаИзмерения,
	|		Количество КАК Количество,
	|		Характеристика КАК Характеристика
	|	) КАК ТаблицаМатериалыЗаказчика,
	|	ЗаказПокупателя.СерииНоменклатуры.(
	|		Серия КАК Серия,
	|		КлючСвязи КАК КлючСвязи
	|	) КАК ТаблицаСерииНоменклатуры,
	|	ЗаказПокупателя.ДобавленныеНаборы.(
	|		НоменклатураНабора КАК НоменклатураНабора,
	|		ХарактеристикаНабора КАК ХарактеристикаНабора,
	|		Количество КАК Количество,
	|		ВЫБОР
	|			КОГДА (ВЫРАЗИТЬ(ЗаказПокупателя.ДобавленныеНаборы.НоменклатураНабора.НаименованиеПолное КАК СТРОКА(1000))) = """"
	|				ТОГДА ЗаказПокупателя.ДобавленныеНаборы.НоменклатураНабора.Наименование
	|			ИНАЧЕ ВЫРАЗИТЬ(ЗаказПокупателя.ДобавленныеНаборы.НоменклатураНабора.НаименованиеПолное КАК СТРОКА(1000))
	|		КОНЕЦ КАК ЗапасНабора,
	|		НоменклатураНабора.ВариантПечатиНабора КАК ВариантПечатиНабора,
	|		НоменклатураНабора.ТипНоменклатуры КАК ТипНоменклатурыНабора,
	|		НоменклатураНабора.Артикул КАК АртикулНабора,
	|		НоменклатураНабора.Код КАК КодНабора,
	|		НоменклатураНабора.ЕдиницаИзмерения КАК ЕдиницаИзмеренияНабора,
	|		НоменклатураНабора.ЕдиницаИзмерения.Код КАК КодЕдиницыИзмеренияНабора,
	|		ИСТИНА КАК ВыводитьИтоги
	|	) КАК ТаблицаДобавленныеНаборы,
	|	ЗаказПокупателя.Исполнители.(
	|		КлючСвязи КАК КлючСвязи
	|	) КАК ТаблицаИсполнители
	|ИЗ
	|	Документ.ЗаказПокупателя КАК ЗаказПокупателя
	|ГДЕ
	|	ЗаказПокупателя.Ссылка В(&МассивОбъектов)
	|
	|УПОРЯДОЧИТЬ ПО
	|	ЗаказПокупателя.Дата,
	|	ЗаказПокупателя.Работы.НомерСтроки,
	|	ЗаказПокупателя.Запасы.НомерСтроки";

	ДанныеДокументов = Запрос.Выполнить().Выгрузить();

	// Наборы
	НаборыСервер.КомпоноватьТабличнуюЧастьПоНаборам(ДанныеДокументов, "ТаблицаЗапасы", Ошибки);
	НаборыСервер.КомпоноватьТабличнуюЧастьПоНаборам(ДанныеДокументов, "ТаблицаРаботы", Ошибки);

	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("МассивОбъектов", МассивОбъектов);
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ЕСТЬNULL(ФИОФизЛиц.Фамилия, """") КАК Фамилия,
	|	ЕСТЬNULL(ФИОФизЛиц.Имя, """") КАК Имя,
	|	ЕСТЬNULL(ФИОФизЛиц.Отчество, """") КАК Отчество,
	|	МаксимальныеПериоды.Физлицо КАК Физлицо,
	|	МаксимальныеПериоды.КлючСвязи КАК КлючСвязи,
	|	МаксимальныеПериоды.Ссылка КАК Ссылка
	|ИЗ
	|	(ВЫБРАТЬ
	|		МАКСИМУМ(ФИОФизЛиц.Период) КАК Период,
	|		ЗаказПокупателяИсполнители.Сотрудник.Физлицо КАК Физлицо,
	|		ЗаказПокупателяИсполнители.КлючСвязи КАК КлючСвязи,
	|		ЗаказПокупателяИсполнители.Ссылка КАК Ссылка
	|	ИЗ
	|		Документ.ЗаказПокупателя.Исполнители КАК ЗаказПокупателяИсполнители
	|			ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ФИОФизЛиц КАК ФИОФизЛиц
	|			ПО ЗаказПокупателяИсполнители.Сотрудник.Физлицо = ФИОФизЛиц.ФизЛицо
	|				И (ФИОФизЛиц.Период <= ЗаказПокупателяИсполнители.Ссылка.Дата)
	|	ГДЕ
	|		ЗаказПокупателяИсполнители.Ссылка В(&МассивОбъектов)
	|	
	|	СГРУППИРОВАТЬ ПО
	|		ЗаказПокупателяИсполнители.Сотрудник.Физлицо,
	|		ЗаказПокупателяИсполнители.КлючСвязи,
	|		ЗаказПокупателяИсполнители.Ссылка) КАК МаксимальныеПериоды
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ФИОФизЛиц КАК ФИОФизЛиц
	|		ПО МаксимальныеПериоды.Физлицо = ФИОФизЛиц.ФизЛицо
	|			И МаксимальныеПериоды.Период = ФИОФизЛиц.Период";

	ТаблицаИсполнители = Запрос.Выполнить().Выгрузить();

	Для каждого СтрокаТабличнойЧасти Из ДанныеДокументов Цикл
		СтруктураОтбора = Новый Структура;
		СтруктураОтбора.Вставить("Ссылка", СтрокаТабличнойЧасти.Ссылка);
		СтрокаТабличнойЧасти.ТаблицаИсполнители = ТаблицаИсполнители.Скопировать(СтруктураОтбора);
	КонецЦикла; 

	Для каждого Шапка Из ДанныеДокументов Цикл

		СведенияОбОрганизации = ПечатьДокументовУНФ.СведенияОЮрФизЛице(Шапка.Организация, Шапка.ДатаДокумента, ,);
		СведенияОбКонтрагенте = ПечатьДокументовУНФ.СведенияОЮрФизЛице(Шапка.Контрагент, Шапка.ДатаДокумента, ,);

		НомерДокумента = ПечатьДокументовУНФ.ПолучитьНомерНаПечатьСУчетомДатыДокумента(Шапка.ДатаДокумента,
		Шапка.Номер, Шапка.Префикс);

		ДанныеПечати = Новый Структура;
		ДанныеПечати.Вставить("ТекстЗаголовка", СтрШаблон(НСтр("ru = 'Заказ-наряд № %1 от %2'"), НомерДокумента, Формат(
		Шапка.ДатаДокумента, "ДЛФ=DD")));
		ДанныеПечати.Вставить("ПредставлениеПоставщика", ПечатьДокументовУНФ.ОписаниеОрганизации(СведенияОбОрганизации,
		"ПолноеНаименование,ИНН,КПП,ЮридическийАдрес,Телефоны,"));
		ДанныеПечати.Вставить("ПредставлениеПолучателя", ПечатьДокументовУНФ.ОписаниеОрганизации(СведенияОбКонтрагенте,
		"ПолноеНаименование,ИНН,КПП,РегистрационныйНомер,ЮридическийАдрес,Телефоны,"));

		ОбластьЗаголовок = Макет.ПолучитьОбласть("Заголовок");
		ОбластьЗаголовок.Параметры.Заполнить(ДанныеПечати);
		ШтрихкодированиеПечатныхФорм.ВывестиШтрихкодВТабличныйДокумент(ТабличныйДокумент, Макет, ОбластьЗаголовок,
		Шапка.Ссылка);
		ТабличныйДокумент.Вывести(ОбластьЗаголовок);

		ОбластьПоставщик = Макет.ПолучитьОбласть("Поставщик");
		ОбластьПоставщик.Параметры.Заполнить(ДанныеПечати);
		ТабличныйДокумент.Вывести(ОбластьПоставщик);

		ОбластьПокупатель = Макет.ПолучитьОбласть("Покупатель");
		ОбластьПокупатель.Параметры.Заполнить(ДанныеПечати);
		ТабличныйДокумент.Вывести(ОбластьПокупатель);

		ОбластьСроки = Макет.ПолучитьОбласть("Сроки");
		ОбластьСроки.Параметры.Заполнить(Шапка);
		ТабличныйДокумент.Вывести(ОбластьСроки);
		
		#Вставка
		ОбластьМакета = Макет.ПолучитьОбласть("тм_Автомобиль");
		ОбластьМакета.Параметры.Автомобиль = Шапка.Ссылка.тм_Автомобиль;
		ОбластьМакета.Параметры.Пробег	   = Шапка.Ссылка.тм_Пробег;
		ОбластьМакета.Параметры.ГосударственныйНомер = Шапка.Ссылка.тм_Автомобиль.ГосударственныйНомер;
		ОбластьМакета.Параметры.VIN	   = Шапка.Ссылка.тм_Автомобиль.VIN;
		ТабличныйДокумент.Вывести(ОбластьМакета);
		
		Если тм_ОбщегоНазначенияВызовСервера.ВключенаФункциональнаяОпция("тм_ИспользоватьБонуснуюСистему") Тогда
			ОбластьМакета = Макет.ПолучитьОбласть("тм_БонуснаяПрограмма");
			ДанныеБП = тм_ОбщегоНазначенияВызовСервера.ПолучитьДанныеПоБонуснойПрограмме(МассивОбъектов);	
			
			ЗаполнитьЗначенияСвойств(ОбластьМакета.Параметры, ДанныеБП);
			
			ТабличныйДокумент.Вывести(ОбластьМакета);			
		КонецЕсли;  
		#КонецВставки
		// РАБОТЫ
		ЕстьСкидки = Шапка.ТаблицаРаботы.Итог("ЕстьСкидка") <> 0;
		СтруктураИтогов = Новый Структура;
		СтруктураИтогов.Вставить("НомерСтроки", 0);
		СтруктураИтогов.Вставить("СуммаРаботы", 0);
		СтруктураИтогов.Вставить("СуммаНДСРаботы", 0);
		СтруктураИтогов.Вставить("СуммаТовары", 0);
		СтруктураИтогов.Вставить("СуммаНДСТовары", 0);
		СтруктураИтогов.Вставить("Сумма", 0);
		СтруктураИтогов.Вставить("СуммаНДС", 0);
		СтруктураИтогов.Вставить("Всего", 0);
		СтруктураИтогов.Вставить("Количество", 0);
		СтруктураИтогов.Вставить("ЕстьСкидки", ЕстьСкидки);
		СтруктураИтогов.Вставить("СкидкаПоДокументу", 0);
		СтруктураИтогов.Вставить("СкидкаПоСтроке", 0);
		СтруктураИтогов.Вставить("ПредставлениеСкидки", ПредставлениеСкидки);

		ПараметрыНоменклатуры = Новый Структура;

		Если СтруктураИтогов.ЕстьСкидки Тогда

			ОбластьМакета = Макет.ПолучитьОбласть("ШапкаТаблицыСоСкидкойРаботы");
			ТабличныйДокумент.Вывести(ОбластьМакета);
			ОбластьМакета = Макет.ПолучитьОбласть("СтрокаСоСкидкойРаботы");

		Иначе

			#Удаление 
			ОбластьМакета = Макет.ПолучитьОбласть("ШапкаТаблицыРаботы");
			ТабличныйДокумент.Вывести(ОбластьМакета);
			ОбластьМакета = Макет.ПолучитьОбласть("СтрокаРаботы");
			#КонецУдаления
			#Вставка
			ОбластьМакета = Макет.ПолучитьОбласть("тм_ШапкаТаблицыРаботы");
			ТабличныйДокумент.Вывести(ОбластьМакета);
			ОбластьМакета = Макет.ПолучитьОбласть("СтрокаРаботы");
			#КонецВставки		

		КонецЕсли;

		Для каждого СтрокаРаботы Из Шапка.ТаблицаРаботы Цикл

			ОбластьМакета.Параметры.Заполнить(СтрокаРаботы);

			ЗаполнитьДанныеПечатиПоСтрокеТабличнойЧастиЗаказНаряд(СтрокаРаботы, ДанныеПечати, ПараметрыНоменклатуры,
			СтруктураИтогов);

			СтруктураОтбора = Новый Структура;
			СтруктураОтбора.Вставить("КлючСвязи", СтрокаРаботы.КлючСвязи);
			СтрокиИсполнители = Шапка.ТаблицаИсполнители.НайтиСтроки(СтруктураОтбора);

			Исполнители = Новый Массив;
			Для Каждого СтрИсполнитель Из СтрокиИсполнители Цикл
				ПредставлениеСотрудник = ФизическиеЛицаКлиентСервер.ФамилияИнициалы(СтрИсполнитель);
				Если ЗначениеЗаполнено(ПредставлениеСотрудник) Тогда
					Исполнители.Добавить(ПредставлениеСотрудник);
				Иначе
					Исполнители.Добавить(СтрИсполнитель.Физлицо);
				КонецЕсли;
			КонецЦикла; 
			ДанныеПечати.Вставить("Исполнители", СтрСоединить(Исполнители, ", "));

			Если НЕ СтрокаРаботы.ЭтоНабор Тогда
				СтруктураИтогов.СуммаРаботы		= СтруктураИтогов.СуммаРаботы	 + СтрокаРаботы.Сумма;
				СтруктураИтогов.СуммаНДСРаботы	= СтруктураИтогов.СуммаНДСРаботы + СтрокаРаботы.СуммаНДС;
			КонецЕсли; 

			ОбластьМакета.Параметры.Заполнить(СтрокаРаботы);
			ОбластьМакета.Параметры.Заполнить(ДанныеПечати);
			ТабличныйДокумент.Вывести(ОбластьМакета);

			// Наборы
			НаборыСервер.УчестьОформлениеСтрокиНабора(ТабличныйДокумент, ОбластьМакета, СтрокаРаботы);

		КонецЦикла;

		ОбластьИтогоРаботы = Макет.ПолучитьОбласть("ИтогоРаботы");
		ОбластьИтогоРаботы.Параметры.Всего = ПечатьДокументовУНФ.ФорматСумм(СтруктураИтогов.СуммаРаботы);
		ТабличныйДокумент.Вывести(ОбластьИтогоРаботы);

		ОбластьИтогоНДСРаботы = Макет.ПолучитьОбласть("ИтогоНДСРаботы");
		ЗаполнитьПараметрыНДС(ОбластьИтогоНДСРаботы, СтруктураИтогов.СуммаНДС, СтруктураИтогов.СуммаНДСРаботы, Шапка);
		ТабличныйДокумент.Вывести(ОбластьИтогоНДСРаботы);

		// ТОВАРЫ
		СтруктураИтогов.Вставить("НомерСтроки", 0);
		Если Шапка.ТаблицаЗапасы.Количество() > 0 Тогда

			ЕстьСкидки = Шапка.ТаблицаЗапасы.Итог("ЕстьСкидка") <> 0;
			СтруктураИтогов.Вставить("ЕстьСкидки", ЕстьСкидки);

			Если СтруктураИтогов.ЕстьСкидки Тогда

				ОбластьМакета = Макет.ПолучитьОбласть("ШапкаТаблицыСоСкидкойТовары");
				ТабличныйДокумент.Вывести(ОбластьМакета);
				ОбластьМакета = Макет.ПолучитьОбласть("СтрокаСоСкидкойТовары");

			Иначе

				ОбластьМакета = Макет.ПолучитьОбласть("ШапкаТаблицыТовары");
				ТабличныйДокумент.Вывести(ОбластьМакета);
				ОбластьМакета = Макет.ПолучитьОбласть("СтрокаТовары");

			КонецЕсли;

			Для каждого СтрокаЗапасы Из Шапка.ТаблицаЗапасы Цикл

				ЗаполнитьДанныеПечатиПоСтрокеТабличнойЧастиЗаказНаряд(СтрокаЗапасы, ДанныеПечати, ПараметрыНоменклатуры, СтруктураИтогов);

				Если НЕ СтрокаЗапасы.ЭтоНабор Тогда
					СтруктураИтогов.СуммаТовары		= СтруктураИтогов.СуммаТовары	 + СтрокаЗапасы.Сумма;
					СтруктураИтогов.СуммаНДСТовары	= СтруктураИтогов.СуммаНДСТовары + СтрокаЗапасы.СуммаНДС;
				КонецЕсли; 

				ОбластьМакета.Параметры.Заполнить(СтрокаЗапасы);
				ОбластьМакета.Параметры.Заполнить(ДанныеПечати);
				ТабличныйДокумент.Вывести(ОбластьМакета);

				// Наборы
				НаборыСервер.УчестьОформлениеСтрокиНабора(ТабличныйДокумент, ОбластьМакета, СтрокаЗапасы);

			КонецЦикла;

			ОбластьИтогоТовары = Макет.ПолучитьОбласть("ИтогоТовары");
			ОбластьИтогоТовары.Параметры.Всего = ПечатьДокументовУНФ.ФорматСумм(СтруктураИтогов.СуммаТовары);
			ТабличныйДокумент.Вывести(ОбластьИтогоТовары);

			ОбластьИтогоНДСТовары = Макет.ПолучитьОбласть("ИтогоНДСТовары");
			ЗаполнитьПараметрыНДС(ОбластьИтогоНДСТовары, СтруктураИтогов.СуммаНДС, СтруктураИтогов.СуммаНДСТовары, Шапка);
			ТабличныйДокумент.Вывести(ОбластьИтогоНДСТовары);

		КонецЕсли; 

		// МАТЕРИАЛЫ ЗАКАЗЧИКА
		Если Шапка.ТаблицаМатериалыЗаказчика.Количество() > 0 Тогда

			ОбластьМакета = Макет.ПолучитьОбласть("ШапкаТаблицыМатериалыЗаказчика");
			ТабличныйДокумент.Вывести(ОбластьМакета);
			ОбластьМакета = Макет.ПолучитьОбласть("СтрокаМатериалыЗаказчика");

			Для каждого СтрокаМатериалыЗаказчика Из Шапка.ТаблицаМатериалыЗаказчика Цикл

				ОбластьМакета.Параметры.Заполнить(СтрокаМатериалыЗаказчика);

				ОбластьМакета.Параметры.Товар = ПечатьДокументовУНФ.ПредставлениеНоменклатурыДляПечати(СтрокаМатериалыЗаказчика.Товар, 
				СтрокаМатериалыЗаказчика.Характеристика, СтрокаМатериалыЗаказчика.Артикул);
				ТабличныйДокумент.Вывести(ОбластьМакета);

			КонецЦикла;

			ОбластьМакета = Макет.ПолучитьОбласть("ИтогоМатериалыЗаказчика");
			ТабличныйДокумент.Вывести(ОбластьМакета);

		КонецЕсли; 

		// ПОДВАЛ
		ОбластьМакета = Макет.ПолучитьОбласть("СуммаПрописью");
		СуммаКПрописи = СтруктураИтогов.Всего;
		ОбластьМакета.Параметры.ИтоговаяСтрока = "Всего наименований "
		+ Строка(СтруктураИтогов.Количество)
		+ ", на сумму "
		+ ПечатьДокументовУНФ.ФорматСумм(СуммаКПрописи, Шапка.ВалютаДокумента);

		ОбластьМакета.Параметры.СуммаПрописью = РаботаСКурсамиВалют.СформироватьСуммуПрописью(СуммаКПрописи, Шапка.ВалютаДокумента);

		ТабличныйДокумент.Вывести(ОбластьМакета);
		
		#Вставка
		ОбластьМакета = Макет.ПолучитьОбласть("тм_Рекомендации");
		ОбластьМакета.Параметры.ПричинаОбращения = Шапка.Ссылка.тм_ПричинаОбращения;
		ОбластьМакета.Параметры.Рекомендация 	 = Шапка.Ссылка.тм_Рекомендация;
		ТабличныйДокумент.Вывести(ОбластьМакета);
		#КонецВставки				
		ОбластьМакета = Макет.ПолучитьОбласть("Подписи");
		ОбластьМакета.Параметры.Заполнить(Шапка);
		ТабличныйДокумент.Вывести(ОбластьМакета);

		УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ТабличныйДокумент, НомерСтрокиНачало, ОбъектыПечати, Шапка.Ссылка);

	КонецЦикла; 

КонецПроцедуры


&ИзменениеИКонтроль("СформироватьЗаказПокупателя")
Процедура тм_СформироватьЗаказПокупателя(ПечатнаяФорма, МассивОбъектов, ОбъектыПечати, Ошибки)
	Перем ПервыйДокумент, НомерСтрокиНачало;

	ТабличныйДокумент = ПечатнаяФорма.ТабличныйДокумент;
	Макет = УправлениеПечатью.МакетПечатнойФормы(ПечатнаяФорма.ПолныйПутьКМакету);
	ПредставлениеСкидки = Константы.ПредставлениеСкидкиВПечатнойФорме.Получить();

	Запрос = Новый Запрос();
	Запрос.УстановитьПараметр("МассивОбъектов", МассивОбъектов);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ЗаказПокупателя.Ссылка КАК Ссылка,
	|	ЗаказПокупателя.Номер КАК Номер,
	|	ЗаказПокупателя.Дата КАК ДатаДокумента,
	|	ЗаказПокупателя.Организация КАК Организация,
	|	ЗаказПокупателя.Контрагент КАК Контрагент,
	|	ЗаказПокупателя.АдресДоставки КАК АдресДоставки,
	|	ЗаказПокупателя.Грузополучатель КАК Грузополучатель,
	|	ЗаказПокупателя.СуммаВключаетНДС КАК СуммаВключаетНДС,
	|	ЗаказПокупателя.ВалютаДокумента КАК ВалютаДокумента,
	|	ЗаказПокупателя.Ответственный КАК Ответственный,
	|	ЗаказПокупателя.Организация.Префикс КАК Префикс,
	|	ЗаказПокупателя.ОсновнойВариантКП КАК ОсновнойВариантКП,
	|	ЗаказПокупателя.ОжидаетсяВыборВариантаКП КАК ОжидаетсяВыборВариантаКП,
	|	ЗаказПокупателя.СпособДоставки КАК СпособДоставки,
	|	ЗаказПокупателя.Вес КАК Вес,
	|	ВЫБОР
	|		КОГДА ЗаказПокупателя.ВидОперации = ЗНАЧЕНИЕ(Перечисление.ВидыОперацийЗаказПокупателя.ЗаказНаряд)
	|				ИЛИ ЗаказПокупателя.СпособДоставки В (ЗНАЧЕНИЕ(Перечисление.СпособыДоставки.ПустаяСсылка), ЗНАЧЕНИЕ(Перечисление.СпособыДоставки.Самовывоз))
	|			ТОГДА ЗНАЧЕНИЕ(Справочник.Номенклатура.ПустаяСсылка)
	|		ИНАЧЕ ЗаказПокупателя.НоменклатураДоставки
	|	КОНЕЦ КАК НоменклатураДоставки,
	|	ВЫБОР
	|		КОГДА (ВЫРАЗИТЬ(ЗаказПокупателя.НоменклатураДоставки.НаименованиеПолное КАК СТРОКА(1000))) = """"
	|			ТОГДА ЗаказПокупателя.НоменклатураДоставки.Наименование
	|		ИНАЧЕ ВЫРАЗИТЬ(ЗаказПокупателя.НоменклатураДоставки.НаименованиеПолное КАК СТРОКА(1000))
	|	КОНЕЦ КАК ПредставлениеНоменклатурыДоставки,
	|	ЗаказПокупателя.НоменклатураДоставки.Код КАК КодДоставки,
	|	ЗаказПокупателя.НоменклатураДоставки.Артикул КАК АртикулДоставки,
	|	ЗаказПокупателя.НоменклатураДоставки.ЕдиницаИзмерения КАК ЕдиницаИзмеренияДоставки,
	|	ЗаказПокупателя.СтоимостьДоставки КАК СтоимостьДоставки,
	|	ЗаказПокупателя.СуммаНДСДоставки КАК СуммаНДСДоставки,
	|	ЗаказПокупателя.СтавкаНДСДоставки КАК СтавкаНДСДоставки,
	|	ЗаказПокупателя.Работы.(
	|		НомерСтроки КАК НомерСтроки,
	|		0 КАК НомерВариантаКП,
	|		ВЫБОР
	|			КОГДА (ВЫРАЗИТЬ(ЗаказПокупателя.Работы.Номенклатура.НаименованиеПолное КАК СТРОКА(1000))) = """"
	|				ТОГДА ЗаказПокупателя.Работы.Номенклатура.Наименование
	|			ИНАЧЕ ВЫРАЗИТЬ(ЗаказПокупателя.Работы.Номенклатура.НаименованиеПолное КАК СТРОКА(1000))
	|		КОНЕЦ КАК ПредставлениеНоменклатуры,
	|		Номенклатура.Код КАК Код,
	|		Номенклатура.Артикул КАК Артикул,
	|		Номенклатура.Штрихкод КАК Штрихкод,
	|		Номенклатура.ЕдиницаИзмерения.Наименование КАК ЕдиницаИзмерения,
	|		ЗаказПокупателя.Работы.Количество * ЗаказПокупателя.Работы.Коэффициент * ЗаказПокупателя.Работы.Кратность КАК Количество,
	|		Цена КАК Цена,
	|		Сумма КАК Сумма,
	|		СтавкаНДС КАК СтавкаНДС,
	|		СуммаНДС КАК СуммаНДС,
	|		Всего КАК Всего,
	|		0 КАК Вес,
	|		Характеристика КАК Характеристика,
	|		ПроцентСкидкиНаценки КАК ПроцентСкидкиНаценки,
	|		ВЫБОР
	|			КОГДА ЗаказПокупателя.Работы.ПроцентСкидкиНаценки <> 0
	|					ИЛИ ЗаказПокупателя.Работы.СуммаАвтоматическойСкидки <> 0
	|				ТОГДА 1
	|			ИНАЧЕ 0
	|		КОНЕЦ КАК ЕстьСкидка,
	|		Содержание КАК Содержание,
	|		Ссылка.Старт КАК ДатаОтгрузки,
	|		СуммаАвтоматическойСкидки КАК СуммаАвтоматическойСкидки,
	|		ЛОЖЬ КАК ЭтоРазделитель,
	|		ЛОЖЬ КАК ЭтоНабор,
	|		ВЫБОР
	|			КОГДА ЗаказПокупателя.Работы.НоменклатураНабора <> ЗНАЧЕНИЕ(Справочник.Номенклатура.ПустаяСсылка)
	|					И ЗаказПокупателя.Работы.НоменклатураНабора.ВариантПечатиНабора = ЗНАЧЕНИЕ(Перечисление.ВариантыПечатиНаборов.НаборИКомплектующие)
	|				ТОГДА ИСТИНА
	|			ИНАЧЕ ЛОЖЬ
	|		КОНЕЦ КАК НеобходимоВыделитьКакСоставНабора,
	|		НоменклатураНабора КАК НоменклатураНабора,
	|		ХарактеристикаНабора КАК ХарактеристикаНабора
	|	) КАК ТаблицаРаботыУслуги,
	|	ЗаказПокупателя.Запасы.(
	|		НомерСтроки КАК НомерСтроки,
	|		НомерВариантаКП КАК НомерВариантаКП,
	|		ВЫБОР
	|			КОГДА ТИПЗНАЧЕНИЯ(ЗаказПокупателя.Запасы.Номенклатура) = ТИП(СТРОКА)
	|				ТОГДА ЗаказПокупателя.Запасы.Номенклатура
	|			КОГДА (ВЫРАЗИТЬ(ЗаказПокупателя.Запасы.Номенклатура.НаименованиеПолное КАК СТРОКА(1000))) = """"
	|				ТОГДА ЗаказПокупателя.Запасы.Номенклатура.Наименование
	|			ИНАЧЕ ВЫРАЗИТЬ(ЗаказПокупателя.Запасы.Номенклатура.НаименованиеПолное КАК СТРОКА(1000))
	|		КОНЕЦ КАК ПредставлениеНоменклатуры,
	|		Номенклатура.Код КАК Код,
	|		Номенклатура.Артикул КАК Артикул,
	|		Номенклатура.Штрихкод КАК Штрихкод,
	|		ЕдиницаИзмерения.Наименование КАК ЕдиницаИзмерения,
	|		Количество КАК Количество,
	|		Цена КАК Цена,
	|		Сумма КАК Сумма,
	|		СтавкаНДС КАК СтавкаНДС,
	|		СуммаНДС КАК СуммаНДС,
	|		Всего КАК Всего,
	|		Вес КАК Вес,
	|		ВЫБОР
	|			КОГДА ЗаказПокупателя.Запасы.Ссылка.ВидОперации = ЗНАЧЕНИЕ(Перечисление.ВидыОперацийЗаказПокупателя.ЗаказНаряд)
	|				ТОГДА ЗаказПокупателя.Запасы.Ссылка.Старт
	|			ИНАЧЕ ЗаказПокупателя.Запасы.ДатаОтгрузки
	|		КОНЕЦ КАК ДатаОтгрузки,
	|		Характеристика КАК Характеристика,
	|		Содержание КАК Содержание,
	|		ПроцентСкидкиНаценки КАК ПроцентСкидкиНаценки,
	|		ВЫБОР
	|			КОГДА ЗаказПокупателя.Запасы.ПроцентСкидкиНаценки <> 0
	|					ИЛИ ЗаказПокупателя.Запасы.СуммаАвтоматическойСкидки <> 0
	|				ТОГДА 1
	|			ИНАЧЕ 0
	|		КОНЕЦ КАК ЕстьСкидка,
	|		СуммаАвтоматическойСкидки КАК СуммаАвтоматическойСкидки,
	|		ЭтоРазделитель КАК ЭтоРазделитель,
	|		ЛОЖЬ КАК ЭтоНабор,
	|		ВЫБОР
	|			КОГДА ЗаказПокупателя.Запасы.НоменклатураНабора <> ЗНАЧЕНИЕ(Справочник.Номенклатура.ПустаяСсылка)
	|					И ЗаказПокупателя.Запасы.НоменклатураНабора.ВариантПечатиНабора = ЗНАЧЕНИЕ(Перечисление.ВариантыПечатиНаборов.НаборИКомплектующие)
	|				ТОГДА ИСТИНА
	|			ИНАЧЕ ЛОЖЬ
	|		КОНЕЦ КАК НеобходимоВыделитьКакСоставНабора,
	|		НоменклатураНабора КАК НоменклатураНабора,
	|		ХарактеристикаНабора КАК ХарактеристикаНабора
	|	) КАК ТаблицаЗапасы,
	|	ЗаказПокупателя.ДобавленныеНаборы.(
	|		НоменклатураНабора КАК НоменклатураНабора,
	|		ХарактеристикаНабора КАК ХарактеристикаНабора,
	|		НомерВариантаКП КАК НомерВариантаКП,
	|		Количество КАК Количество,
	|		ВЫБОР
	|			КОГДА (ВЫРАЗИТЬ(ЗаказПокупателя.ДобавленныеНаборы.НоменклатураНабора.НаименованиеПолное КАК СТРОКА(1000))) = """"
	|				ТОГДА ЗаказПокупателя.ДобавленныеНаборы.НоменклатураНабора.Наименование
	|			ИНАЧЕ ВЫРАЗИТЬ(ЗаказПокупателя.ДобавленныеНаборы.НоменклатураНабора.НаименованиеПолное КАК СТРОКА(1000))
	|		КОНЕЦ КАК ЗапасНабора,
	|		НоменклатураНабора.ВариантПечатиНабора КАК ВариантПечатиНабора,
	|		НоменклатураНабора.ТипНоменклатуры КАК ТипНоменклатурыНабора,
	|		НоменклатураНабора.Артикул КАК АртикулНабора,
	|		НоменклатураНабора.Код КАК КодНабора,
	|		НоменклатураНабора.ЕдиницаИзмерения КАК ЕдиницаИзмеренияНабора,
	|		НоменклатураНабора.ЕдиницаИзмерения.Код КАК КодЕдиницыИзмеренияНабора,
	|		ИСТИНА КАК ВыводитьИтоги
	|	) КАК ТаблицаДобавленныеНаборы
	|ИЗ
	|	Документ.ЗаказПокупателя КАК ЗаказПокупателя
	|ГДЕ
	|	ЗаказПокупателя.Ссылка В(&МассивОбъектов)
	|	И (ЗаказПокупателя.ОсновнойВариантКП = 0
	|			ИЛИ ЗаказПокупателя.Запасы.НомерВариантаКП = ЗаказПокупателя.ОсновнойВариантКП)
	|
	|УПОРЯДОЧИТЬ ПО
	|	Ссылка,
	|	ЗаказПокупателя.Работы.НомерСтроки,
	|	ЗаказПокупателя.Запасы.НомерСтроки";

	ДанныеДокументов = Запрос.Выполнить().Выгрузить();
	ДоставкаСервер.ДобавитьСтрокуДоставкиУниверсальныеДанные(ДанныеДокументов);

	// Наборы
	НаборыСервер.КомпоноватьТабличнуюЧастьПоНаборам(ДанныеДокументов, "ТаблицаЗапасы", Ошибки, Истина);
	НаборыСервер.КомпоноватьТабличнуюЧастьПоНаборам(ДанныеДокументов, "ТаблицаРаботыУслуги", Ошибки);

	Для каждого Шапка Из ДанныеДокументов Цикл

		Если Шапка.ОжидаетсяВыборВариантаКП Тогда
			Сообщение = Новый СообщениеПользователю;
			Сообщение.Текст = СтрШаблон(
			НСтр("ru='Печатная форма ""%1"" (%2) не может быть сформирована: не выбран основной вариант.'"),
			ПечатнаяФорма.СинонимМакета,
			Шапка.Ссылка
			);
			Сообщение.КлючДанных = Шапка.Ссылка;
			Сообщение.Сообщить();
			Продолжить;
		КонецЕсли;

		ПечатьДокументовУНФ.ПередНачаломФормированияДокумента(ТабличныйДокумент, ПервыйДокумент, НомерСтрокиНачало);

		СведенияОбОрганизации = ПечатьДокументовУНФ.СведенияОЮрФизЛице(Шапка.Организация, Шапка.ДатаДокумента, ,);
		СведенияОбКонтрагенте = ПечатьДокументовУНФ.СведенияОЮрФизЛице(Шапка.Контрагент, Шапка.ДатаДокумента, ,);
		// Доставка
		ГрузополучательЗаполнен = (ЗначениеЗаполнено(Шапка.Грузополучатель) И Шапка.Грузополучатель <> Шапка.Контрагент);
		Если ГрузополучательЗаполнен Тогда
			СведенияОбКонтрагенте.Вставить("Грузополучатель", Шапка.Грузополучатель);
		КонецЕсли; 
		АдресДоставкиЗаполнен = (НЕ ПустаяСтрока(Шапка.АдресДоставки) И Шапка.АдресДоставки <> СведенияОбКонтрагенте.ЮридическийАдрес);
		Если АдресДоставкиЗаполнен Тогда
			СведенияОбКонтрагенте.Вставить("АдресДоставки", Шапка.АдресДоставки);
		КонецЕсли;
		// Конец Доставка

		ТекстЗаголовка = СтрШаблон(
		НСтр("ru='Заказ покупателя № %1 от %2'"),
		ПечатьДокументовУНФ.ПолучитьНомерНаПечатьСУчетомДатыДокумента(Шапка.ДатаДокумента, Шапка.Номер, Шапка.Префикс),
		ПечатьДокументовУНФ.ПредставлениеДатыВДокументах(Шапка.ДатаДокумента)
		);

		ДанныеПечати = Новый Структура;
		ДанныеПечати.Вставить("ТекстЗаголовка", ТекстЗаголовка);
		ДанныеПечати.Вставить("ПредставлениеПоставщика", ПечатьДокументовУНФ.ОписаниеОрганизации(
		СведенияОбОрганизации, "ПолноеНаименование,ИНН,КПП,ЮридическийАдрес,Телефоны,"));
		ДанныеПечати.Вставить("ПредставлениеПолучателя", ПечатьДокументовУНФ.ОписаниеОрганизации(
		СведенияОбКонтрагенте, "ПолноеНаименование,ИНН,КПП,РегистрационныйНомер,ЮридическийАдрес,Телефоны,Грузополучатель,АдресДоставки,"));

		ОбластьЗаголовок = Макет.ПолучитьОбласть("Заголовок");
		ОбластьЗаголовок.Параметры.Заполнить(ДанныеПечати);
		ШтрихкодированиеПечатныхФорм.ВывестиШтрихкодВТабличныйДокумент(ТабличныйДокумент, Макет, ОбластьЗаголовок,
		Шапка.Ссылка);
		ТабличныйДокумент.Вывести(ОбластьЗаголовок);

		ОбластьПоставщик = Макет.ПолучитьОбласть("Поставщик");
		ОбластьПоставщик.Параметры.Заполнить(ДанныеПечати);
		ТабличныйДокумент.Вывести(ОбластьПоставщик);

		ОбластьПокупатель = Макет.ПолучитьОбласть("Покупатель");
		ОбластьПокупатель.Параметры.Заполнить(ДанныеПечати); 
		ТабличныйДокумент.Вывести(ОбластьПокупатель);

		#Вставка
		ОбластьМакета = Макет.ПолучитьОбласть("тм_Автомобиль");
		Если ЗначениеЗаполнено(Шапка.Ссылка.тм_Автомобиль) Тогда
			ОбластьМакета.Параметры.Автомобиль = Шапка.Ссылка.тм_Автомобиль;
			ОбластьМакета.Параметры.ГосударственныйНомер = Шапка.Ссылка.тм_Автомобиль.ГосударственныйНомер;
			ОбластьМакета.Параметры.VIN	= Шапка.Ссылка.тм_Автомобиль.VIN;
		КонецЕсли;  
		ТабличныйДокумент.Вывести(ОбластьМакета);
		#КонецВставки		
		ЕстьСкидки = (Шапка.ТаблицаЗапасы.Итог("ЕстьСкидка") + Шапка.ТаблицаРаботыУслуги.Итог("ЕстьСкидка")) <> 0;
		Если ЕстьСкидки Тогда
			ОбластьМакета = Макет.ПолучитьОбласть("ШапкаТаблицыСоСкидкой");
			ТабличныйДокумент.Вывести(ОбластьМакета);
			ОбластьМакета = Макет.ПолучитьОбласть("СтрокаСоСкидкой");
			ОбластьГруппаРазделитель = Макет.ПолучитьОбласть("СтрокаСоСкидкойГруппировка");
		Иначе
			ОбластьМакета = Макет.ПолучитьОбласть("ШапкаТаблицы");
			ТабличныйДокумент.Вывести(ОбластьМакета);
			ОбластьМакета = Макет.ПолучитьОбласть("Строка");
			ОбластьГруппаРазделитель = Макет.ПолучитьОбласть("СтрокаГруппировка");
		КонецЕсли;

		СтруктураИтогов = Новый Структура;
		СтруктураИтогов.Вставить("Сумма", 0);
		СтруктураИтогов.Вставить("СуммаНДС", 0);
		СтруктураИтогов.Вставить("Всего", 0);
		СтруктураИтогов.Вставить("Количество", 0);
		СтруктураИтогов.Вставить("НомерСтроки", 0);
		СтруктураИтогов.Вставить("Вес", 0);
		СтруктураИтогов.Вставить("ЕстьСкидки", ЕстьСкидки);
		СтруктураИтогов.Вставить("СкидкаПоСтроке", 0);
		СтруктураИтогов.Вставить("СкидкаПоДокументу", 0);
		СтруктураИтогов.Вставить("ПредставлениеСкидки", ПредставлениеСкидки);
		СтруктураИтогов.Вставить("ЕстьСтавкаНольПроцентов", Ложь);

		ПараметрыНоменклатуры = Новый Структура;

		Для каждого СтрокаРаботыУслуги Из Шапка.ТаблицаРаботыУслуги Цикл

			ЗаполнитьДанныеПечатиПоСтрокеТабличнойЧастиЗаказПокупателя(СтрокаРаботыУслуги, ДанныеПечати,
			ПараметрыНоменклатуры, СтруктураИтогов);

			ОбластьМакета.Параметры.Заполнить(СтрокаРаботыУслуги);
			ОбластьМакета.Параметры.Заполнить(ДанныеПечати);
			ТабличныйДокумент.Вывести(ОбластьМакета);

			// Наборы
			НаборыСервер.УчестьОформлениеСтрокиНабора(ТабличныйДокумент, ОбластьМакета, СтрокаРаботыУслуги);

		КонецЦикла;

		Для каждого СтрокаЗапасы Из Шапка.ТаблицаЗапасы Цикл

			Если СтрокаЗапасы.ЭтоРазделитель Тогда
				СтруктураИтогов.НомерСтроки = 0;
				ОбластьГруппаРазделитель.Параметры.Заполнить(СтрокаЗапасы);
				ДанныеПечати.Очистить();
				ДанныеПечати.Вставить("Запас", СтрокаЗапасы.ПредставлениеНоменклатуры);
				ОбластьГруппаРазделитель.Параметры.Заполнить(ДанныеПечати);
				ТабличныйДокумент.Вывести(ОбластьГруппаРазделитель);
				Продолжить;
			КонецЕсли; 

			ЗаполнитьДанныеПечатиПоСтрокеТабличнойЧастиЗаказПокупателя(СтрокаЗапасы, ДанныеПечати,
			ПараметрыНоменклатуры, СтруктураИтогов);

			ОбластьМакета.Параметры.Заполнить(СтрокаЗапасы);
			ОбластьМакета.Параметры.Заполнить(ДанныеПечати);
			ТабличныйДокумент.Вывести(ОбластьМакета);

			// Наборы
			НаборыСервер.УчестьОформлениеСтрокиНабора(ТабличныйДокумент, ОбластьМакета, СтрокаЗапасы);

		КонецЦикла;

		ДанныеПечати.Очистить();
		ДанныеПечати.Вставить("Всего", ПечатьДокументовУНФ.ФорматСумм(СтруктураИтогов.Сумма));
		ДанныеПечати.Вставить("НДС", ПечатьДокументовУНФ.ПредставлениеЗаголовкаНДС(СтруктураИтогов.СуммаНДС,
		Шапка.СуммаВключаетНДС, Ложь, СтруктураИтогов.ЕстьСтавкаНольПроцентов));
		ДанныеПечати.Вставить("ВсегоНДС", ?(СтруктураИтогов.СуммаНДС = 0 И Не СтруктураИтогов.ЕстьСтавкаНольПроцентов,
		"-", ПечатьДокументовУНФ.ФорматСумм(СтруктураИтогов.СуммаНДС, , "0,00")));
		ДанныеПечати.Вставить("ИтоговаяСтрока", ПечатьДокументовУНФ.ИтоговаяСтрока(СтруктураИтогов.Количество,
		СтруктураИтогов.Всего, Шапка.ВалютаДокумента));
		ДанныеПечати.Вставить("СуммаПрописью", РаботаСКурсамиВалют.СформироватьСуммуПрописью(СтруктураИтогов.Всего,
		Шапка.ВалютаДокумента));
		ДанныеПечати.Вставить("Отпустил", Шапка.Ответственный);

		ОбластьМакета = Макет.ПолучитьОбласть("Итого");
		ОбластьМакета.Параметры.Заполнить(ДанныеПечати);
		ТабличныйДокумент.Вывести(ОбластьМакета);

		ОбластьМакета = Макет.ПолучитьОбласть("ИтогоНДС");
		ОбластьМакета.Параметры.Заполнить(ДанныеПечати);
		ТабличныйДокумент.Вывести(ОбластьМакета);

		Если СтруктураИтогов.ЕстьСкидки Тогда

			ОбластьМакета = ПечатьДокументовУНФ.ПолучитьОбластьБезопасно(Макет, "ИтогоСкидка", "", Ошибки);
			Если ОбластьМакета <> Неопределено Тогда

				ОбластьМакета.Параметры.Заполнить(СтруктураИтогов);
				ТабличныйДокумент.Вывести(ОбластьМакета);

			КонецЕсли;

		КонецЕсли;

		ОбластьМакета = ПечатьДокументовУНФ.ПолучитьОбластьБезопасно(Макет, "ИтогоВес", "", Ошибки);
		Если ОбластьМакета <> Неопределено Тогда

			ОбластьМакета.Параметры.Вес = 0;
			Если СтруктураИтогов.Вес <> 0 Тогда

				ОбластьМакета.Параметры.Вес = СтруктураИтогов.Вес;

			ИначеЕсли Шапка.Вес <> 0 Тогда

				ОбластьМакета.Параметры.Вес = Шапка.Вес;

			КонецЕсли;

			Если ОбластьМакета.Параметры.Вес <> 0 Тогда

				ТабличныйДокумент.Вывести(ОбластьМакета);

			КонецЕсли;

		КонецЕсли;

		ОбластьМакета = Макет.ПолучитьОбласть("СуммаПрописью");
		ОбластьМакета.Параметры.Заполнить(ДанныеПечати);
		ТабличныйДокумент.Вывести(ОбластьМакета);

		ОбластьМакета = Макет.ПолучитьОбласть("Подписи");
		ОбластьМакета.Параметры.Заполнить(ДанныеПечати);
		ТабличныйДокумент.Вывести(ОбластьМакета);

		УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ТабличныйДокумент, НомерСтрокиНачало, ОбъектыПечати, Шапка.Ссылка);

	КонецЦикла;

КонецПроцедуры

