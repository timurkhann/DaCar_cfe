﻿#Область ОписаниеПеременных

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура тм_ПриСозданииНаСервереПосле(Отказ, СтандартнаяОбработка)	
	
	Результат = тм_ОбщегоНазначенияВызовСервера.ПроверитьДоступыОткрытияДокумента(Отказ, ЭтотОбъект.ИмяФормы);
	
	Если Результат.Отказ Тогда
		ОбщегоНазначения.СообщитьПользователю(Результат.ПричинаОтказа,,,, Отказ); 
		Возврат;
	КонецЕсли; 
	
	ДобавитьВставитьЭлементыНаФорму();
	
	ДобавитьКоманды();

	//Блокировка документа от ввода данных
	ЗаблокироватьРазблокироватьДокумент();
	
	ЗаполнитьРеквизитыПоУмолчанию();
	
	тм_ОбщегоНазначенияВызовСервера.ВывестиЗакупочныеЦены(Объект.Запасы);
	тм_ОбщегоНазначенияВызовСервера.ВывестиПроизводителя(Объект.Запасы);
	тм_ОбщегоНазначенияВызовСервера.ВывестиОписаниеХарактеристики(Объект.Работы);
	
	тм_ПереопределяемыйСервер.ПереопределитьПараметрыВыбора(ЭтотОбъект);

КонецПроцедуры

&НаКлиенте
Процедура тм_ПриОткрытииПосле(Отказ)
	
	тм_УправлениеДоступом();
	
КонецПроцедуры

&НаСервере
Процедура тм_ПередЗаписьюНаСервереПеред(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	ПроверитьЗаполненияРеквизитов(Отказ, ТекущийОбъект);

	// Избавит от лишних блокировок формы
	Если Не ЗначениеЗаполнено(Параметры.Ключ) Тогда
		ТекущийОбъект.ДополнительныеСвойства.Вставить("тм_ЭтоНовыйДокумент", Истина);
	КонецЕсли; 	
	
	// Право
	ТолькоПроведение = тм_ОбщегоНазначенияВызовСервера.НастройкиПользователей("Разрешено только проведение документа", ПараметрыСеанса.ТекущийПользователь, Ложь);
	Если ТолькоПроведение 
		И ПараметрыЗаписи.РежимЗаписи = РежимЗаписиДокумента.Запись Тогда
		Отказ = Истина;
		Сообщить("Разрешено только ПРОВЕДЕНИЕ документа!", СтатусСообщения.ОченьВажное);
	КонецЕсли;  
	
КонецПроцедуры

&НаСервере
Процедура тм_ПослеЗаписиНаСервереПосле(ТекущийОбъект, ПараметрыЗаписи)
	
	Если ТекущийОбъект.ДополнительныеСвойства.Свойство("тм_ЭтоНовыйДокумент") Тогда
		ЗаблокироватьРазблокироватьДокумент();
	КонецЕсли; 
		
КонецПроцедуры

&НаКлиенте
Процедура тм_ПриЗакрытииПосле(ЗавершениеРаботы)
	
	//Разблокировка документа от ввода данных
	ЗаблокироватьРазблокироватьДокумент(Ложь);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура АвтомобильПриИзмененииДанных(Элемент)

	АвтомобильПриИзмененииДанныхНаСервере(); 
 	
КонецПроцедуры 

&НаКлиенте
Процедура тм_ЗНКонтрагентПриИзмененииПосле(Элемент)
	
	Объект.тм_Пробег = 0;
	Если ЗначениеЗаполнено(Объект.Контрагент) Тогда
				
		ИнформацияОКлиенте = ПолучитьИнформациюОКлиенте(Объект.Контрагент);
		Если Не ПустаяСтрока(ИнформацияОКлиенте) Тогда
			
			ФорматированнаяСтрока = Новый ФорматированнаяСтрока(ИнформацияОКлиенте,, Новый Цвет(255, 0, 0)); 
			ПредупреждениеАсинх(ФорматированнаяСтрока,, "Обратите внимание");
			
		КонецЕсли; 
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ИсполнительПриИзмененииДанных(Элемент)

	Запрет = Ложь;
	ТекущиеДанные = Элементы.Работы.ТекущиеДанные;
	ИсполнительПриИзмененииДанныхНаСервере(ТекущиеДанные.Номенклатура, Запрет); 
	
	Если Запрет Тогда
		ТекущиеДанные.тм_Сотрудник = ПредопределенноеЗначение("Справочник.Сотрудники.ПустаяСсылка");
		ПоказатьПредупреждение(, "Для работ с типом ""Услуга"" исполнитель не указывается!");	
	КонецЕсли; 
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормы

&НаКлиенте
Процедура тм_ЗапасыНоменклатураПриИзмененииПосле(Элемент)
	
	Номенклатура = Элементы.Запасы.ТекущиеДанные.Номенклатура;
	Если Не Номенклатура.Пустая() Тогда                                        
		тм_ОбщегоНазначенияВызовСервера.ВывестиЗакупочнуюЦенуПриИзмененииНоменклатуры(Элементы.Запасы.ТекущиеДанные.тм_ЗакупочнаяЦена, Номенклатура);
		тм_ОбщегоНазначенияВызовСервера.ВывестиПроизводителя(Номенклатура, Элементы.Запасы.ТекущиеДанные.тм_Производитель);
	КонецЕсли;   
	
	УстановитьТекущегоСотрудника();
	ОбновитьДопРеквизитыПодвала();
	
КонецПроцедуры

&НаКлиенте
Процедура тм_РаботыСпецификацияПриИзмененииПосле(Элемент)
	
	Спецификация = Элементы.Работы.ТекущиеДанные.Спецификация;
	Если Не Спецификация.Пустая() Тогда                                        
		тм_ОбщегоНазначенияВызовСервера.ВывестиОписаниеХарактеристики(Спецификация, Элементы.Работы.ТекущиеДанные.тм_ОписаниеСпецификации);   
	Иначе
		Элементы.Работы.ТекущиеДанные.тм_ОписаниеСпецификации = "";
	КонецЕсли;                                    
	
КонецПроцедуры

&НаКлиенте
Процедура тм_ЗНРаботыНоменклатураПриИзмененииПосле(Элемент)
	
	тм_Работа = Элементы.Работы.ТекущиеДанные.Номенклатура;
	//тм_ОписаниеСпецификации = Элементы.Работы.ТекущиеДанные.тм_ОписаниеСпецификации;
	УстановитьСпецификацию(тм_Работа, Элементы.Работы.ТекущиеДанные.тм_ОписаниеСпецификации);
	УстановитьЦенуРаботы(тм_Работа, Элементы.Работы.ТекущиеДанные.Цена);
	РаботыЦенаПриИзменении("");
	
	ОбновитьДопРеквизитыПодвала();
	
КонецПроцедуры

&НаКлиенте
Процедура тм_РаботыСпецификацияСозданиеПосле(Элемент, СтандартнаяОбработка)
		
	СтандартнаяОбработка = Ложь;
	
	ЗначенияЗаполнения = Новый Структура;
	ЗначенияЗаполнения.Вставить("Владелец", Элементы.Работы.ТекущиеДанные.Номенклатура); 
	ЗначенияЗаполнения.Вставить("Наименование", ПолучитьНаименованиеСпецификации(Элементы.Работы.ТекущиеДанные.Номенклатура));
	
	ПараметрыПередачи = Новый Структура;
	ПараметрыПередачи.Вставить("ЗначенияЗаполнения", ЗначенияЗаполнения);
	
	ОткрытьФорму("Справочник.Спецификации.ФормаОбъекта", ПараметрыПередачи); 
		
КонецПроцедуры

&НаКлиенте
Процедура тм_ЗНРаботыКратностьПриИзмененииПосле(Элемент)
	
	ОбновитьДопРеквизитыПодвала();
	
КонецПроцедуры

&НаКлиенте
Процедура тм_ЗНРаботыЦенаПриИзмененииПосле(Элемент)
	
	ОбновитьДопРеквизитыПодвала();	
	
КонецПроцедуры

&НаКлиенте
Процедура тм_ЗапасыЦенаПриИзмененииПосле(Элемент)

	ОбновитьДопРеквизитыПодвала();		
	
КонецПроцедуры

&НаКлиенте
Процедура тм_ЗапасыКоличествоПриИзмененииПосле(Элемент)

	ОбновитьДопРеквизитыПодвала();			
	
КонецПроцедуры

&НаКлиенте
Процедура тм_ЗапасыПослеУдаленияПосле(Элемент)
	
	ОбновитьДопРеквизитыПодвала();				
	
КонецПроцедуры

&НаКлиенте
Процедура тм_РаботыПослеУдаленияПосле(Элемент)

	ОбновитьДопРеквизитыПодвала();				

КонецПроцедуры

&НаКлиенте
Процедура тм_ТаблицаИсторияОбслуживанияВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)

	Если Поле.Имя = "тм_КолонкаДокумент" Тогда
		ТекущаяСтрока = Элемент.ТекущиеДанные;
		ПоказатьЗначение(, ТекущаяСтрока.Документ);
	КонецЕсли;  	
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура СписатьБонусы(Команда)
	
	ПараметрыПередачи = Новый Структура;
	ПараметрыПередачи.Вставить("КоличествоДоступныхБонусов", тм_ОбщегоНазначенияВызовСервера.ПолучитьОстатокБонусов(Объект.Контрагент));
	
	Оповещение = Новый ОписаниеОповещения("ПослеСписанияБонусов", ЭтаФорма);
	ОткрытьФорму("ОбщаяФорма.тм_ФормаСписанияБонусов", ПараметрыПередачи,,,,, Оповещение);
	
КонецПроцедуры

&НаКлиенте
Процедура ОчиститьБонусы(Команда)
	
	ОчиститьБонусыНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура СохранитьДополнительныеРеквизиты(Команда)
	
	Если Не ЗначениеЗаполнено(Параметры.Ключ) Тогда
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'Необходимо записать документ'")); 
		Возврат;
		
	КонецЕсли; 
	
	СохранитьЗначенияРеквизитов();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура тм_УправлениеДоступом()
	
	Если Не тм_ОбщегоНазначенияВызовСервера.ВключенаФункциональнаяОпция("тм_ИспользованиеФункционалаЧата") Тогда	
		тм_РаботаСФормойКлиент.ОтключитьВидимостьЭлементов(ЭтотОбъект, "ФормаОбщаяКомандатм_Чат");	
	КонецЕсли;
		
КонецПроцедуры 
 
&НаСервере
Процедура ДобавитьКоманды()

	#Область БонуснаяСистема_Команды
	
	СтраницаБонуснаяСистема = Элементы.Найти("БонуснаяСистема");
	// Создадим команды
    Команда		= ЭтаФорма.Команды.Добавить("СписатьБонусы");
    Команда.Действие	= "СписатьБонусы";
	
    КомандаОчиститьБонусы = ЭтаФорма.Команды.Добавить("ОчиститьБонусы");
    КомандаОчиститьБонусы.Действие = "ОчиститьБонусы";

	
    // Создадим кнопку и привяжем к ней команду    	
	КнопкаСписатьБонусы = тм_ОбщегоНазначенияВызовСервера.ДобавитьЭлементНаФорму(ЭтаФорма, 
		"СписатьБонусы",
		Тип("КнопкаФормы"),
		Неопределено,
		СтраницаБонуснаяСистема,
		Неопределено); 	
	КнопкаСписатьБонусы.Заголовок	= "Списать бонусы";
	КнопкаСписатьБонусы.ИмяКоманды	= "СписатьБонусы";
	КнопкаСписатьБонусы.ЦветФона = WebЦвета.Желтый;

	КнопкаОчиститьБонусы = тм_ОбщегоНазначенияВызовСервера.ДобавитьЭлементНаФорму(ЭтаФорма, 
		"ОчиститьБонусы",
		Тип("КнопкаФормы"),
		Неопределено,
		СтраницаБонуснаяСистема,
		Неопределено); 	
	КнопкаОчиститьБонусы.Заголовок	= "Очистить бонусы";
	КнопкаОчиститьБонусы.ИмяКоманды	= "ОчиститьБонусы";
	
	#КонецОбласти 

	#Область ДополнительныеРеквизиты_Команды
	
	СтраницаДополнительныеРеквизиты = Элементы.Найти("тм_ДополнительныеРеквизиты");
	// Создадим команды
    Команда				= ЭтаФорма.Команды.Добавить("СохранитьДополнительныеРеквизиты");
    Команда.Действие 	= "СохранитьДополнительныеРеквизиты";

    // Создадим кнопку и привяжем к ней команду    	
	КнопкаСохранитьДопРеквизиты = тм_ОбщегоНазначенияВызовСервера.ДобавитьЭлементНаФорму(ЭтаФорма, 
		"СохранитьДополнительныеРеквизиты",
		Тип("КнопкаФормы"),
		Неопределено,
		СтраницаДополнительныеРеквизиты,
		Неопределено); 	
		
	КнопкаСохранитьДопРеквизиты.Заголовок	= "Сохранить";
	КнопкаСохранитьДопРеквизиты.ИмяКоманды	= "СохранитьДополнительныеРеквизиты";
	КнопкаСохранитьДопРеквизиты.ЦветФона 	= WebЦвета.СлоноваяКость;
	
	#КонецОбласти 
	
КонецПроцедуры // ДобавитьКоманды()
 
&НаСервере
Процедура ДобавитьВставитьЭлементыНаФорму()

#Область Авто
	
	Группа = тм_ОбщегоНазначенияВызовСервера.ВставитьЭлементНаФорму(ЭтаФорма, 
				"ГруппаАвто",
				Тип("ГруппаФормы"),
				ВидГруппыФормы.ОбычнаяГруппа,
				Элементы.ЗНЛеваяКолонка,
				"",
				Элементы.ЗНДоговор);

	Группа.Группировка = ГруппировкаПодчиненныхЭлементовФормы.ГоризонтальнаяВсегда;
	Группа.Отображение = ОтображениеОбычнойГруппы.Нет;
	Группа.ОтображатьЗаголовок = Ложь;
	
	ЭлементАвтомобиль = тм_ОбщегоНазначенияВызовСервера.ДобавитьЭлементНаФорму(ЭтаФорма, 
		"Автомобиль",
		Тип("ПолеФормы"),
		ВидПоляФормы.ПолеВвода,
		Группа,
		"Объект.тм_Автомобиль"); 
		
	тм_ОбщегоНазначенияВызовСервера.ДобавитьЭлементНаФорму(ЭтаФорма, 
		"Пробег",
		Тип("ПолеФормы"),
		ВидПоляФормы.ПолеВвода,
		Группа,
		"Объект.тм_Пробег"); 	
		
	ЭлементИсполнитель = тм_ОбщегоНазначенияВызовСервера.ДобавитьЭлементНаФорму(ЭтаФорма, 
		"Исполнитель",
		Тип("ПолеФормы"),
		ВидПоляФормы.ПолеВвода,
		ЭтаФорма.Элементы.Работы,
		"Объект.Работы.тм_Сотрудник"); 
		
	//События элементов
	ЭлементАвтомобиль.УстановитьДействие("ПриИзменении", "АвтомобильПриИзмененииДанных");
	ЭлементИсполнитель.УстановитьДействие("ПриИзменении", "ИсполнительПриИзмененииДанных");
	
	тм_ОбщегоНазначенияВызовСервера.ДобавитьЭлементНаФорму(ЭтаФорма, 
		"Магазин",
		Тип("ПолеФормы"),
		ВидПоляФормы.ПолеНадписи,
		Элементы.ЗНГруппаДополнительныеРеквизиты,
		"Объект.тм_Магазин");	
	
#КонецОбласти
	
#Область БонуснаяСистема
	
	СтраницаБонуснаяСистема = тм_ОбщегоНазначенияВызовСервера.ДобавитьЭлементНаФорму(ЭтаФорма, 
		"БонуснаяСистема",
		Тип("ГруппаФормы"),
		ВидГруппыФормы.Страница,
		Элементы.ЗНСтраницы,
		Неопределено); 
    СтраницаБонуснаяСистема.Заголовок = "Бонусная система";
	
	ИспользованныеБонусы = тм_ОбщегоНазначенияВызовСервера.ДобавитьЭлементНаФорму(ЭтаФорма, 
		"тм_ИспользованныеБонусы",
		Тип("ПолеФормы"),
		ВидПоляФормы.ПолеВвода,
		СтраницаБонуснаяСистема,
		"Объект.тм_ИспользованныеБонусы"); 	
	ИспользованныеБонусы.Заголовок = "Использованные бонусы";
	ИспользованныеБонусы.Доступность = Ложь;
        
	//НовыйЭлемент2 = Элементы.Добавить("НоваяНадпись",Тип("ДекорацияФормы"),СтраницаБонуснаяСистема);
	//НовыйЭлемент2.Заголовок = "НоваяНадпись";	

#КонецОбласти 

#Область ЗакупочнаяЦена
	
	ДобавляемыеРеквизиты	= Новый Массив;                   
		
    Реквизит_тм_ЗакупочнаяЦена = Новый РеквизитФормы("тм_ЗакупочнаяЦена", Новый ОписаниеТипов("Число", , , Новый КвалификаторыЧисла(15, 2)), "Объект.Запасы",  "Цена (закупки)");
	
    ДобавляемыеРеквизиты.Добавить(Реквизит_тм_ЗакупочнаяЦена);
	
    ИзменитьРеквизиты(ДобавляемыеРеквизиты);		
		
	ЭлементЦенаЗакупки = тм_ОбщегоНазначенияВызовСервера.ВставитьЭлементНаФорму(ЭтаФорма, 
		"ЗакупочнаяЦена",
		Тип("ПолеФормы"),
		ВидПоляФормы.ПолеВвода,
		ЭтаФорма.Элементы.Запасы,
		"Объект.Запасы.тм_ЗакупочнаяЦена", Элементы.ЗапасыЦена); 
		
	ЭлементЦенаЗакупки.Заголовок = "Цена (закупки)";	
	ЭлементЦенаЗакупки.Доступность = Ложь;	
	
#КонецОбласти 
	
#Область Производитель
	
	ДобавляемыеРеквизиты	= Новый Массив;                   
		
    Реквизит_тм_Производитель = Новый РеквизитФормы("тм_Производитель", Новый ОписаниеТипов("Строка",,,, Новый КвалификаторыСтроки(50)), "Объект.Запасы",  "Производитель");
	
    ДобавляемыеРеквизиты.Добавить(Реквизит_тм_Производитель);
	
    ИзменитьРеквизиты(ДобавляемыеРеквизиты);		
		
	ЭлементПроизводитель = тм_ОбщегоНазначенияВызовСервера.ВставитьЭлементНаФорму(ЭтаФорма, 
		"Производитель",                                                                                  	
		Тип("ПолеФормы"),
		ВидПоляФормы.ПолеВвода,
		ЭтаФорма.Элементы.Запасы,
		"Объект.Запасы.тм_Производитель", Элементы.ЗапасыХарактеристика); 
		
	ЭлементПроизводитель.Заголовок = "Производитель";	
	ЭлементПроизводитель.Доступность = Ложь;	
	
#КонецОбласти 
			
#Область ПричинаОбращения_Рекомендации

	ГруппаРекомендации = тм_ОбщегоНазначенияВызовСервера.ДобавитьЭлементНаФорму(ЭтаФорма, 
				"ГруппаРекомендации",
				Тип("ГруппаФормы"),
				ВидГруппыФормы.ОбычнаяГруппа,
				Элементы.ЗНГруппаДополнительно,
				Неопределено
				);

	ГруппаРекомендации.Группировка = ГруппировкаПодчиненныхЭлементовФормы.ГоризонтальнаяВсегда;
	ГруппаРекомендации.Отображение = ОтображениеОбычнойГруппы.СлабоеВыделение;
	ГруппаРекомендации.Заголовок   = "Причина обращения/рекомендации";
	
	ЭлементПричинаОбращения = тм_ОбщегоНазначенияВызовСервера.ДобавитьЭлементНаФорму(ЭтаФорма, 
		"ПричинаОбращения",
		Тип("ПолеФормы"),
		ВидПоляФормы.ПолеВвода,
		ГруппаРекомендации,
		"Объект.тм_ПричинаОбращения"); 
		
	ЭлементПричинаОбращения.МногострочныйРежим = Истина;		
		
	ЭлементРекомендация = тм_ОбщегоНазначенияВызовСервера.ДобавитьЭлементНаФорму(ЭтаФорма, 
		"Рекомендация",
		Тип("ПолеФормы"),
		ВидПоляФормы.ПолеВвода,
		ГруппаРекомендации,
		"Объект.тм_Рекомендация");
		
	ЭлементРекомендация.МногострочныйРежим = Истина;	
	
#КонецОбласти  		
				
#Область ОписаниеСпецификации

	ДобавляемыеРеквизиты = Новый Массив;                   
		
    Реквизит_тм_ОписаниеСпецификация = Новый РеквизитФормы("тм_ОписаниеСпецификации", Новый ОписаниеТипов("Строка",,,, Новый КвалификаторыСтроки(250)), "Объект.Работы",  "Описание спецификации");

	ДобавляемыеРеквизиты.Добавить(Реквизит_тм_ОписаниеСпецификация);
	
    ИзменитьРеквизиты(ДобавляемыеРеквизиты);		
		
	ЭлементОписаниеСпецификация = тм_ОбщегоНазначенияВызовСервера.ДобавитьЭлементНаФорму(ЭтаФорма, 
		"тм_ОписаниеСпецификации",                                                                                  	
		Тип("ПолеФормы"),
		ВидПоляФормы.ПолеВвода,
		ЭтаФорма.Элементы.Работы,
		"Объект.Работы.тм_ОписаниеСпецификации");
		
	//События элементов
	ЭлементОписаниеСпецификация.КнопкаОткрытия = Истина;
	//ЭлементОписаниеСпецификация.УстановитьДействие("НачалоВыбора", "АвтомобильПриИзмененииДанных");

#КонецОбласти 	
	
#Область СторонаУстановки
		
	Элемент_СторонаУстановки = тм_ОбщегоНазначенияВызовСервера.ВставитьЭлементНаФорму(ЭтаФорма, 
		"тм_СторонаУстановки",                                                                                  	
		Тип("ПолеФормы"),
		ВидПоляФормы.ПолеВвода,
		ЭтаФорма.Элементы.Работы,
		"Объект.Работы.тм_СторонаУстановки", Элементы.ЗНРаботыХарактеристика);
		
	//События элементов

#КонецОбласти 	
	
#Область ВсегоРаботТоваров

	ДобавляемыеРеквизиты	= Новый Массив;                   

	Реквизит_тм_ВсегоРабот 	 = Новый РеквизитФормы("тм_ВсегоРабот", Новый ОписаниеТипов("Число", , , Новый КвалификаторыЧисла(15, 2)), "",  "Всего работ");
	Реквизит_тм_ВсегоТоваров = Новый РеквизитФормы("тм_ВсегоТоваров", Новый ОписаниеТипов("Число", , , Новый КвалификаторыЧисла(15, 2)),"",  "Всего товаров");

	ДобавляемыеРеквизиты.Добавить(Реквизит_тм_ВсегоРабот);
	ДобавляемыеРеквизиты.Добавить(Реквизит_тм_ВсегоТоваров);

	ИзменитьРеквизиты(ДобавляемыеРеквизиты);		

	ЭлементВсегоРабот = тм_ОбщегоНазначенияВызовСервера.ВставитьЭлементНаФорму(ЭтаФорма, 
		"тм_ВсегоРабот",
		Тип("ПолеФормы"),
		ВидПоляФормы.ПолеНадписи,
		ЭтаФорма.Элементы.ЗНИтоги,
		"тм_ВсегоРабот", Элементы.ЗНИтогВсего); 
		
	ЭлементВсегоТоваров = тм_ОбщегоНазначенияВызовСервера.ВставитьЭлементНаФорму(ЭтаФорма, 
		"тм_ВсегоТоваров",
		Тип("ПолеФормы"),
		ВидПоляФормы.ПолеНадписи,
		ЭтаФорма.Элементы.ЗНИтоги,
		"тм_ВсегоТоваров", Элементы.ЗНИтогВсего); 
	

	ЭлементВсегоРабот.Заголовок = "Всего работ";	
	ЭлементВсегоРабот.ТолькоПросмотр = Истина;
	ЭлементВсегоРабот.Ширина = 9;
	
	ЭлементВсегоТоваров.Заголовок = "Всего товаров";	
	ЭлементВсегоТоваров.ТолькоПросмотр = Истина;	
	ЭлементВсегоТоваров.Ширина = 9;
	
	ЭтотОбъект.тм_ВсегоРабот   = Объект.Работы.Итог("Всего");
	ЭтотОбъект.тм_ВсегоТоваров = Объект.Запасы.Итог("Всего");
	
#КонецОбласти 

#Область ИсторияОбслуживания
		
	ГруппаИсторияОбслуживания = тм_ОбщегоНазначенияВызовСервера.ДобавитьЭлементНаФорму(ЭтаФорма, 
		"ГруппаИсторияОбслуживания",
		Тип("ГруппаФормы"),
		ВидГруппыФормы.ОбычнаяГруппа,
		Элементы.ЗНПраваяКолонка,
		Неопределено);

	ГруппаИсторияОбслуживания.Группировка = ГруппировкаПодчиненныхЭлементовФормы.ГоризонтальнаяВсегда;
	ГруппаИсторияОбслуживания.Отображение = ОтображениеОбычнойГруппы.СлабоеВыделение;
	ГруппаИсторияОбслуживания.Заголовок   = "История обслуживания";
	ГруппаИсторияОбслуживания.Поведение   = ПоведениеОбычнойГруппы.Свертываемая;
	
	Таблица = ПолучитьЗаказНаряды();
	
	// добавим таблицу: сначала саму таблицу, потом колонку.
	Реквизиты = Новый Массив;
	Реквизиты.Добавить(Новый РеквизитФормы("тм_ТаблицаИсторияОбслуживания", Новый ОписаниеТипов("ТаблицаЗначений")));
	
	Для Каждого Ст ИЗ Таблица.Колонки Цикл
		Реквизиты.Добавить(Новый РеквизитФормы(Ст.Имя, Ст.ТипЗначения, "тм_ТаблицаИсторияОбслуживания"));
	КонецЦикла;

	// добавим реквизиты на форму
	ИзменитьРеквизиты(Реквизиты);

	// добавим элементы формы
	ЭлементТаблица = тм_ОбщегоНазначенияВызовСервера.ДобавитьЭлементНаФорму(ЭтаФорма, 
		"тм_ЭлементТаблицаИсторияОбслуживания",                                                                                  	
		Тип("ТаблицаФормы"),,
		ГруппаИсторияОбслуживания,
		"тм_ТаблицаИсторияОбслуживания");

	// запретим менять положение строк и сами строки, отключим командную панель
	ЭлементТаблица.ИзменятьСоставСтрок = Ложь;
	ЭлементТаблица.ИзменятьПорядокСтрок = Ложь;
	ЭлементТаблица.ПоложениеКоманднойПанели = ПоложениеКоманднойПанелиЭлементаФормы.Нет;
	
	Для Каждого Ст ИЗ Таблица.Колонки Цикл
		Рек = Элементы.Добавить("тм_Колонка" + Ст.Имя, Тип("ПолеФормы"), ЭлементТаблица);
		Рек.Вид = ВидПоляФормы.ПолеНадписи;
		Рек.ПутьКДанным = "тм_ТаблицаИсторияОбслуживания" + "." + Ст.Имя;
		Рек.Заголовок = Ст.Заголовок;
	КонецЦикла;
	
	ЭлементТаблица.УстановитьДействие("Выбор", "тм_ТаблицаИсторияОбслуживанияВыбор");

	// заполним таблицу
	ЗначениеВРеквизитФормы(Таблица, "тм_ТаблицаИсторияОбслуживания");
	
#КонецОбласти 

#Область ДополнительныеРеквизиты

	ПрефиксРасширения = тм_КЭШ.ПолучитьПрефиксРасширения();
	
	СтраницаДополнительныеРеквизиты = тм_ОбщегоНазначенияВызовСервера.ДобавитьЭлементНаФорму(ЭтаФорма, 
		ПрефиксРасширения + "ДополнительныеРеквизиты",
		Тип("ГруппаФормы"),
		ВидГруппыФормы.Страница,
		Элементы.ЗНСтраницы,
		Неопределено); 
		
    СтраницаДополнительныеРеквизиты.Заголовок = "Дополнительные реквизиты";
	
	РесурсыРегистра = Метаданные.РегистрыСведений.тм_ДополнительныеРеквизитыЗаказНаряда.Ресурсы;
	Для каждого СтрРесурс Из РесурсыРегистра Цикл
		
		ДобавляемыеРеквизиты = Новый Массив;
		НовыйРеквизит = Новый РеквизитФормы(ПрефиксРасширения + СтрРесурс.Имя, СтрРесурс.Тип); 
		ДобавляемыеРеквизиты.Добавить(НовыйРеквизит); 
		ИзменитьРеквизиты(ДобавляемыеРеквизиты);
		
		ЭлементДоп = тм_ОбщегоНазначенияВызовСервера.ДобавитьЭлементНаФорму(ЭтаФорма, 
			СтрРесурс.Имя,
			Тип("ПолеФормы"),
			ВидПоляФормы.ПолеВвода,
			СтраницаДополнительныеРеквизиты,
			ПрефиксРасширения + СтрРесурс.Имя);
			
		ЭлементДоп.Заголовок = СтрРесурс.Синоним;
		ЭлементДоп.ПоложениеЗаголовка = ПоложениеЗаголовкаЭлементаФормы.Верх;

		Если СтрРесурс.Имя = "ДополнительныйКомментарий" Тогда
			
			ЭлементДоп.МногострочныйРежим = Истина;
			
		КонецЕсли; 
		
	КонецЦикла; 

#КонецОбласти 

#Область Запасы

	Права = тм_КЭШ.ПолучитьПраваОбъекта("ЗаказПокупателя", Пользователи.ТекущийПользователь());
	Если Права.SA Тогда
		
		Элемент_тм_Сотрудник = тм_ОбщегоНазначенияВызовСервера.ДобавитьЭлементНаФорму(ЭтаФорма, 
			"Сотрудник",
			Тип("ПолеФормы"),
			ВидПоляФормы.ПолеВвода,
			ЭтаФорма.Элементы.Запасы,
			"Объект.Запасы.тм_Сотрудник"); 
			
		Элемент_тм_Сотрудник.Доступность = Ложь;	
			
	КонецЕсли; 

#КонецОбласти 

КонецПроцедуры // ДобавитьВставитьЭлементыНаФорму()

&НаСервере
Процедура АвтомобильПриИзмененииДанныхНаСервере()

	Если ЗначениеЗаполнено(Объект.тм_Автомобиль) Тогда
		
		Автомобиль = Объект.тм_Автомобиль;
		Объект.тм_Пробег = Автомобиль.Пробег;
		
	КонецЕсли; 
	
	// Обновим историю обслуживания
	ОбновитьИсторияОбслуживания();
	
КонецПроцедуры 

&НаСервере
Процедура ИсполнительПриИзмененииДанныхНаСервере(Номенклатура, Запрет)
	
	Если Номенклатура.ТипНоменклатуры = Перечисления.ТипыНоменклатуры.Услуга Тогда
		Запрет = Истина;
	КонецЕсли; 
 	
КонецПроцедуры 

&НаСервере
Процедура ПроверитьЗаполненияРеквизитов(Отказ, ТекущийОбъект)

	Если ЗначениеЗаполнено(ТекущийОбъект.тм_Автомобиль) И ТекущийОбъект.тм_Пробег = 0 Тогда          
		Сообщение = Новый СообщениеПользователю;
		Сообщение.Текст = "Необходимо указать пробег авто!";
		Сообщение.Поле = "тм_Пробег";
		Сообщение.ПутьКДанным = "Объект";
		Сообщение.Сообщить(); 
		//Сообщить("Необходимо указать пробег авто!");
		Отказ = Истина;
		Возврат;
	ИначеЕсли Не ЗначениеЗаполнено(Параметры.Ключ) Тогда
		Если ЗначениеЗаполнено(ТекущийОбъект.тм_Автомобиль) Тогда
			Если ТекущийОбъект.тм_Автомобиль.Пробег = ТекущийОбъект.тм_Пробег Тогда
				Сообщение = Новый СообщениеПользователю;
				Сообщение.Текст = "Пробег авто совпадает с предыдущим значением! Необходимо изменить пробег!";
				Сообщение.Поле = "тм_Пробег";
				Сообщение.ПутьКДанным = "Объект";
				Сообщение.Сообщить(); 			
				//Сообщить("Пробег авто совпадает с предыдущим значением! Необходимо изменить пробег!");
				Отказ = Истина;
				Возврат;		
			ИначеЕсли ТекущийОбъект.тм_Автомобиль.Пробег > ТекущийОбъект.тм_Пробег Тогда
				Сообщение = Новый СообщениеПользователю;
				Сообщение.Текст = "Пробег авто меньше текущего! Необходимо изменить пробег!";
				Сообщение.Поле = "тм_Пробег";
				Сообщение.ПутьКДанным = "Объект";
				Сообщение.Сообщить(); 			
				//Сообщить("Пробег авто совпадает с предыдущим значением! Необходимо изменить пробег!");
				Отказ = Истина;
				Возврат;	
			КонецЕсли; 
		КонецЕсли; 		
	КонецЕсли; 
	
	Для каждого СтрокаРабот Из ТекущийОбъект.Работы Цикл
		Если СтрокаРабот.тм_Сотрудник.Пустая() И СтрокаРабот.Номенклатура.ТипНоменклатуры <> Перечисления.ТипыНоменклатуры.Услуга Тогда
			Сообщить("Не указан исполнитель работы [" + СтрокаРабот.Номенклатура +"]");
			Отказ = Истина;
		ИначеЕсли Не СтрокаРабот.тм_Сотрудник.Пустая() И СтрокаРабот.Номенклатура.ТипНоменклатуры = Перечисления.ТипыНоменклатуры.Услуга Тогда
			СтрокаРабот.тм_Сотрудник = Справочники.Сотрудники.ПустаяСсылка();
		КонецЕсли; 		
	КонецЦикла;  	

КонецПроцедуры

&НаСервере
Процедура ЗаблокироватьРазблокироватьДокумент(Заблокировать = Истина)
	
	тм_ОбщегоНазначенияВызовСервера.ЗаблокироватьРазблокироватьФорму(ЭтаФорма, Заблокировать);		
	
КонецПроцедуры // РазблокироватьДокумент()

&НаКлиенте
Процедура ПослеСписанияБонусов(ИспользованныеБонусы, ДополнительныеПараметры) Экспорт

	Если ТипЗнч(ИспользованныеБонусы) = Тип("Неопределено") Тогда
		Возврат;
	КонецЕсли; 
	
	Если ИспользованныеБонусы > Объект.СуммаДокумента Тогда
		Объект.тм_ИспользованныеБонусы = Объект.СуммаДокумента;	
	Иначе
		Объект.тм_ИспользованныеБонусы = ИспользованныеБонусы;		
	КонецЕсли; 

КонецПроцедуры // ПослеСписанияБонусов()
 
&НаСервере
Процедура ОчиститьБонусыНаСервере()
	
	тм_ИспользованныеБонусы = 0;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьРеквизитыПоУмолчанию()

	НастройкиСотрудников = РегистрыСведений.тм_НастройкиСотрудников.Получить(Новый Структура("Сотрудник", Объект.Ответственный));
	//Магазин
	Объект.тм_Магазин = НастройкиСотрудников.Магазин;
	
	ПрефиксРасширения = тм_КЭШ.ПолучитьПрефиксРасширения();
	ДополнительныеРеквизиты = РегистрыСведений.тм_ДополнительныеРеквизитыЗаказНаряда.Получить(Новый Структура("ЗаказНаряд", Объект.Ссылка));
	Для каждого ДопРеквизит Из ДополнительныеРеквизиты Цикл
		
		ЭтаФорма[ПрефиксРасширения + ДопРеквизит.Ключ] = ДопРеквизит.Значение;      	
		
	КонецЦикла;  

КонецПроцедуры // ЗаполнитьРеквизитыПоУмолчанию()

&НаСервере
Процедура УстановитьСпецификацию(тм_Работа, ОписаниеСпецификации)
	
	МЗ = РегистрыСведений.тм_СпецификацияРаботАвтомобилей.СоздатьМенеджерЗаписи();
	МЗ.Работа = тм_Работа;
	МЗ.Автомобиль = Объект.тм_Автомобиль.Автомобиль;
	
	МЗ.Прочитать();
	
	Если НЕ МЗ.Выбран() Тогда
		Возврат;
	КонецЕсли; 
		
	СпецификацияПоУмолчанию = МЗ.Спецификация;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	Спецификации.Ссылка КАК Ссылка
		|ИЗ
		|	Справочник.Спецификации КАК Спецификации
		|ГДЕ
		|	Спецификации.Владелец = &Владелец
		|	И Спецификации.Ссылка = &СпецификацияПоУмолчанию";
	
	Запрос.УстановитьПараметр("Владелец", тм_Работа);
	Запрос.УстановитьПараметр("СпецификацияПоУмолчанию", СпецификацияПоУмолчанию);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Если РезультатЗапроса.Пустой() Тогда
		Возврат;
	КонецЕсли;
	
	Выборка = РезультатЗапроса.Выбрать();
	Пока Выборка.Следующий() Цикл
		тмРаботы = РеквизитФормыВЗначение("Объект.Работы");
		
		ИскомыеРаботы = тмРаботы.НайтиСтроки(Новый Структура("Номенклатура", тм_Работа));
		Для каждого СтрРабота Из ИскомыеРаботы Цикл
			СтрРабота.Спецификация = СпецификацияПоУмолчанию;
			тм_ОбщегоНазначенияВызовСервера.ВывестиОписаниеХарактеристики(СтрРабота.Спецификация, ОписаниеСпецификации);
		КонецЦикла;  		
	КонецЦикла; 
		
КонецПроцедуры // УстановитьСпецификацию()

&НаСервере
Процедура УстановитьЦенуРаботы(Работа, Цена)

	Автомобиль 	 = Объект.тм_Автомобиль.Автомобиль;
	МодельКузова = Объект.тм_Автомобиль.МодельКузова;
	Если Не ЗначениеЗаполнено(Автомобиль) Тогда
		Возврат;
	КонецЕсли; 	
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	тм_ЦеныРаботАвтомобилейСрезПоследних.Цена КАК Цена
		|ИЗ
		|	РегистрСведений.тм_ЦеныРаботАвтомобилей.СрезПоследних(
		|			&Дата,
		|			Работа = &Работа
		|				И Автомобиль = &Автомобиль
		|				И МодельКузова = &МодельКузова) КАК тм_ЦеныРаботАвтомобилейСрезПоследних";
	
	Запрос.УстановитьПараметр("Автомобиль", Автомобиль);
	Запрос.УстановитьПараметр("МодельКузова", МодельКузова);
	Запрос.УстановитьПараметр("Дата", ТекущаяДатаСеанса());
	Запрос.УстановитьПараметр("Работа", Работа);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Выборка = РезультатЗапроса.Выбрать();
	
	Если Выборка.Следующий() Тогда
		Цена = Выборка.Цена;		
	КонецЕсли; 

КонецПроцедуры // УстановитьЦенуРаботы()

&НаСервере
Функция ПолучитьНаименованиеСпецификации(Номенклатура)

	Возврат Строка(Номенклатура) + "/" + Строка(Объект.тм_Автомобиль.Автомобиль);

КонецФункции // ПолучитьНаименованиеСпецификации()

&НаКлиенте
Процедура ОбновитьДопРеквизитыПодвала()
	
	ЭтотОбъект.тм_ВсегоРабот   = Объект.Работы.Итог("Всего");
	ЭтотОбъект.тм_ВсегоТоваров = Объект.Запасы.Итог("Всего");
	
КонецПроцедуры // ОбновитьДопРеквизитыПодвала()

&НаСервере
&ИзменениеИКонтроль("ОпределитьВидимостьИУстановитьНастройкиУчетаВНалогообложении")
Процедура тм_ОпределитьВидимостьИУстановитьНастройкиУчетаВНалогообложении()

	ВидимостьГруппыУчетВНУДоИзменения = Элементы.ГруппаУчетВНУ.Видимость;

	Если РегламентированнаяОтчетностьПереопределяемый.ЭтоЮридическоеЛицо(Объект.Организация) Тогда
		Элементы.ГруппаУчетВНУ.Видимость = Ложь;

		Возврат;
	Иначе
		Элементы.ГруппаУчетВНУ.Видимость = Истина;
	КонецЕсли;

	СистемаНалогообложенияСтруктура = РегистрыСведений.СистемыНалогообложенияОрганизаций.ОпределитьСистемуНалогообложенияОрганизации(Объект.Организация, Объект.Дата);

	Если Не СистемаНалогообложенияСтруктура.ПлательщикУСН Тогда
		Элементы.ГруппаУчетВНУ.Видимость = Ложь;
	Иначе
		Элементы.ГруппаУчетВНУ.Видимость = Истина;
	КонецЕсли;

	Если НЕ ЗначениеЗаполнено(Объект.Ссылка) И СистемаНалогообложенияСтруктура.ПлательщикУСН И СистемаНалогообложенияСтруктура.ПлательщикЕНВД Тогда
		Объект.УчитыватьВНУ = НЕ (Объект.Организация.ВидУчетаСтраховыхВзносов = Перечисления.ВидыУчетаСтраховыхВзносов.УчитыватьВЕНВД);
	КонецЕсли;

	ГруппаУчетВНУСталаВидимой = Не ВидимостьГруппыУчетВНУДоИзменения И Элементы.ГруппаУчетВНУ.Видимость;
	ГруппаУчетВНУСталаНевидимой = ВидимостьГруппыУчетВНУДоИзменения И Не Элементы.ГруппаУчетВНУ.Видимость;
	Если Объект.УчитыватьВНУ
		И ((НЕ Элементы.ГруппаУчетВНУ.Видимость И Объект.Ссылка.Пустая())
		Или ГруппаУчетВНУСталаНевидимой) Тогда
		#Удаление
		Объект.УчитыватьВНУ = Ложь;
		Модифицированность = Истина;
 		#КонецУдаления
	ИначеЕсли ГруппаУчетВНУСталаВидимой И Не Объект.УчитыватьВНУ Тогда
		Объект.УчитыватьВНУ = Истина;
		Модифицированность = Истина;
	КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура ОбновитьИсторияОбслуживания()

	Таблица = ПолучитьЗаказНаряды();		
	ЗначениеВРеквизитФормы(Таблица, "тм_ТаблицаИсторияОбслуживания");

КонецПроцедуры // ОбновитьИсторияОбслуживания()
 
&НаСервере
Функция ПолучитьЗаказНаряды()

	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
		|	ЗаказПокупателя.Ссылка КАК Документ,
		|	ЗаказПокупателя.Дата КАК Дата,
		|	ЗаказПокупателя.СостояниеЗаказа КАК СостояниеЗаказа,
		|	ЗаказПокупателя.СуммаДокумента КАК СуммаДокумента
		|ИЗ
		|	Документ.ЗаказПокупателя КАК ЗаказПокупателя
		|ГДЕ
		|	ЗаказПокупателя.ВидОперации = ЗНАЧЕНИЕ(Перечисление.ВидыОперацийЗаказПокупателя.ЗаказНаряд)
		|	И ЗаказПокупателя.Контрагент = &Контрагент
		| 	И ЗаказПокупателя.Ссылка <> &Ссылка";
	
	Запрос.УстановитьПараметр("Контрагент", Объект.Контрагент);
	Запрос.УстановитьПараметр("Автомобиль", Объект.тм_Автомобиль);
	Запрос.УстановитьПараметр("Ссылка", Параметры.Ключ);
	
	Если ЗначениеЗаполнено(Объект.тм_Автомобиль) Тогда
		
		СхемаЗапроса = Новый СхемаЗапроса;
		СхемаЗапроса.УстановитьТекстЗапроса(Запрос.Текст);
		
		ПакетЗапросов = СхемаЗапроса.ПакетЗапросов[0];
		Оператор = СхемаЗапроса.ПакетЗапросов[0].Операторы[0];
		
		Оператор.Отбор.Добавить("ЗаказПокупателя.тм_Автомобиль = &Автомобиль");
	
		Запрос.Текст = СхемаЗапроса.ПолучитьТекстЗапроса();
		
	КонецЕсли; 

	Таблица = Запрос.Выполнить().Выгрузить();

	Возврат Таблица;		
		
КонецФункции // ПолучитьЗаказНаряды()

&НаСервереБезКонтекста
Функция ПолучитьИнформациюОКлиенте(Контрагент)

	ИнформацияОКлиенте = "";
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	КонтрагентыДополнительныеРеквизиты.Значение КАК Значение
		|ИЗ
		|	Справочник.Контрагенты.ДополнительныеРеквизиты КАК КонтрагентыДополнительныеРеквизиты
		|ГДЕ
		|	КонтрагентыДополнительныеРеквизиты.Ссылка = &Контрагент
		|	И КонтрагентыДополнительныеРеквизиты.Свойство = &Свойство";
	
	Запрос.УстановитьПараметр("Контрагент", Контрагент);
	Запрос.УстановитьПараметр("Свойство", ПланыВидовХарактеристик.ДополнительныеРеквизитыИСведения.НайтиПоРеквизиту("Имя", "тм_ИнформацияОКлиенте"));
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Выборка = РезультатЗапроса.Выбрать();
	Если Выборка.Следующий() Тогда
		
		ИнформацияОКлиенте = Выборка.Значение;
		
	КонецЕсли; 
	
	Возврат ИнформацияОКлиенте;

КонецФункции // ПолучитьИнформациюОКлиенте()

&НаСервере
Функция СохранитьЗначенияРеквизитов()

	ПрефиксРасширения = тм_КЭШ.ПолучитьПрефиксРасширения();

	СтруктураРеквизитов = Новый Структура; 
	
	РесурсыРегистра = Метаданные.РегистрыСведений.тм_ДополнительныеРеквизитыЗаказНаряда.Ресурсы;
	Для каждого СтрРесурс Из РесурсыРегистра Цикл
		
		СтруктураРеквизитов.Вставить(СтрРесурс.Имя, ЭтаФорма[ПрефиксРасширения + СтрРесурс.Имя]);
		
	КонецЦикла; 
	
	СтруктураРеквизитов.Вставить("ЗаказНаряд", Объект.Ссылка);
	СтруктураРеквизитов.Вставить("Активность", Истина);
	
	РегистрыСведений.тм_ДополнительныеРеквизитыЗаказНаряда.СохранитьЗначенияРеквизитов(СтруктураРеквизитов);

КонецФункции // СформироватьДанныеДляЗаписи()

&НаСервере
Процедура УстановитьТекущегоСотрудника()

	тм_Сотрудник = ПолучитьТекущегоСотрудникаПользователя();
	Если ЗначениеЗаполнено(тм_Сотрудник) Тогда
		ТекущаяСтрока = Объект.Запасы.НайтиПоИдентификатору(Элементы.Запасы.ТекущаяСтрока);
		ТекущаяСтрока.тм_Сотрудник = тм_Сотрудник;	
	КонецЕсли;  

КонецПроцедуры // УстановитьТекущегоСотрудника()
 
&НаСервереБезКонтекста
Функция ПолучитьТекущегоСотрудникаПользователя()

	Возврат тм_КЭШ.СотрудникПользователя(Пользователи.ТекущийПользователь());

КонецФункции // ПолучитьТекущегоСотрудникаПользователя()
 
#КонецОбласти 

#Область Инициализация


#КонецОбласти 