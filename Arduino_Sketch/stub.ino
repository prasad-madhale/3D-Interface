void setup() {
	// put your setup code here, to run once:
	Serial.begin(115200);
}

void loop() {
	// put your main code here, to run repeatedly:
	
	
	
	Serial.print(random(8000,14000));
	Serial.print(" ");
	Serial.print(random(8000,14000));
	Serial.print(" ");
	Serial.println(random(8000,14000));
	
	
}
