﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура тм_ПриСозданииНаСервереПосле(Отказ, СтандартнаяОбработка)
	
	Если Параметры.ЗначенияЗаполнения.Свойство("Наименование") Тогда
		 Объект.Наименование = Параметры.ЗначенияЗаполнения.Наименование;
	КонецЕсли; 
		
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормы

#КонецОбласти

#Область ОбработчикиКомандФормы

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#КонецОбласти 

