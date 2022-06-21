﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура тм_ПриСозданииНаСервереПосле(Отказ, СтандартнаяОбработка)
	
	ДобавитьВставитьЭлементыНаФорму();
	УстановитьИспользуемыеБонусы();
	

	//тм_Объект = РеквизитФормыВЗначение("Объект");
	//тм_Объект.ИзменитьСуммуДокументаСУчетомБонусов(тм_Объект.ДокументОснование, СуммаДляСписанияБонусов);
	//
	//МассивРеквизитов = Новый Массив; 
	//МассивРеквизитов.Добавить(Новый РеквизитФормы("СуммаДляСписанияБонусов", Новый ОписаниеТипов("Число",,, Новый КвалификаторыЧисла(6))));
	//ИзменитьРеквизиты(МассивРеквизитов);
	//
	//ЭтотОбъект.СуммаДляСписанияБонусов = СуммаДляСписанияБонусов;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормы

#КонецОбласти

#Область ОбработчикиКомандФормы

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ДобавитьВставитьЭлементыНаФорму()

	Если ТипЗнч(Объект.ДокументОснование) = Тип("ДокументСсылка.ПриходнаяНакладная") Тогда
		тм_ОбщегоНазначенияВызовСервера.ДобавитьЭлементНаФорму(ЭтаФорма,
			"НадписьИспользуемыеБонусы", 
			Тип("ДекорацияФормы"), ВидДекорацииФормы.Надпись, Элементы.СуммаВалюта, Неопределено);	
	КонецЕсли; 
	

КонецПроцедуры // ДобавитьВставитьЭлементыНаФорму()
  
&НаСервере
Процедура УстановитьИспользуемыеБонусы()

	Если ТипЗнч(Объект.ДокументОснование) = Тип("ДокументСсылка.ПриходнаяНакладная")  Тогда
		Если Объект.ДокументОснование.ВидОперации = Перечисления.ВидыОперацийПриходнаяНакладная.ВозвратОтПокупателя Тогда
			Элементы.НадписьИспользуемыеБонусы.Заголовок = Новый ФорматированнаяСтрока("Использованные бонусы: " + 
				Объект.ДокументОснование.тм_ДокументОснованиеНачисленияБонусов.тм_ИспользованныеБонусы,
				,
				ЦветаСтиля.ЦветОсобогоТекста);
		КонецЕсли; 		 
	КонецЕсли; 
	
КонецПроцедуры // УстановитьИспользуемыеБонусы()


#КонецОбласти 