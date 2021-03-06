
Процедура ЗаписатьДвижениеДокумента(ЗаказНарядОбъект) Экспорт

	ТаблицаДляЗаписи = Неопределено;
	ЗаказНарядОбъект.ДополнительныеСвойства.Свойство("ДанныеДляЗаписиДвиженияРегистраЗаказНаряды", ТаблицаДляЗаписи);
	Если ТаблицаДляЗаписи.Количество() = 0 Тогда
		Возврат;
	КонецЕсли; 
	
	ДатаЗаписи = ТекущаяДатаСеанса();
	Автомобиль = ЗаказНарядОбъект.тм_Автомобиль;
	
	ЗаказНарядОбъект.Движения.тм_ЗаказНаряды.Записывать = Истина;
	ЗаказНарядОбъект.Движения.тм_ЗаказНаряды.Записать();
	ЗаказНарядОбъект.Движения.тм_ЗаказНаряды.Записывать = Истина;
	
	Для каждого СтрЗаписи Из ТаблицаДляЗаписи Цикл
		Движение = ЗаказНарядОбъект.Движения.тм_ЗаказНаряды.Добавить();
		ЗаполнитьЗначенияСвойств(Движение,СтрЗаписи);
		Движение.Период = ДатаЗаписи;
		Движение.Автомобиль = Автомобиль;
	КонецЦикла;

КонецПроцедуры
 