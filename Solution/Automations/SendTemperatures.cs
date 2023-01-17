namespace TemperatureAnomaly;

public class SendTemperatures : VerilogAutomation
{
    protected override Dependencies Dependencies => Dependencies.None;

	protected override void ApplyAutomation()
	{
		int count = Items[0, "Count"] | 10;
		
		Random random = new Random();

		for(int i = 0; i < count; i++)
		{
			int temperature = random.Next(92, 99);
			if(i > 20 && random.NextDouble() > .75)
				temperature = random.Next(130, 140);

			CodeAfterAutomation += @$"
SendSerialTemperature({temperature});";
		}
	}
}