
Процедура ПриКомпоновкеРезультата(ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка)
	
	КомпоновщикНастроек.ЗагрузитьНастройки(СхемаКомпоновкиДанных.НастройкиПоУмолчанию);
	КомпоновщикНастроек.Настройки.ПараметрыДанных.УстановитьЗначениеПараметра("НачПериода", НачалоМесяца(ТекущаяДатаСеанса()));
   	КомпоновщикНастроек.Настройки.ПараметрыДанных.УстановитьЗначениеПараметра("КонПериода", КонецМесяца(ТекущаяДатаСеанса()));		
	
КонецПроцедуры
