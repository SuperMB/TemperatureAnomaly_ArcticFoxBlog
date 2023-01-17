namespace TemperatureAnomaly;

public class SendSerialTemperature : VerilogAutomation
{
    protected override Dependencies Dependencies => Dependencies.None;

	protected override void ApplyAutomation()
	{
		int value = Items[0, "Value"] | Item.Required;
		string valueBinary = Convert.ToString(value, 2);

		int delayPerPulse = 30;
		int delayDataSet = 10;
		int delayAfterDataSet = delayPerPulse - delayDataSet;
	}
}