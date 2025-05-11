#include <thread>
#include <chrono>

float timeOfTheDay = 0;

class Glass  
{  
public:  
   enum class DrinkType {
	   WATER,
	   JUICE,
	   MILK,
	   TEA,
	   COFFEE,
	   SODA,
	   SMOOTHIE,
	   HOT_CHOCOLATE
   }
   DrinkType drink = Drink::WATER;
   Glass(DrinkType d){
	   drink = d;
   }
   float volume = 0;  
   float maxVolume = 100;  
   bool isEmpty() const
   {  
       return volume <= 0;  
   };  
};

class User
{
public:
	bool isThirsty = true;
	void Drink(Glass* glass) {
		if (glass->volume >= 10) {
			glass->volume -= 10;
		}
		else {
			glass->volume = 0;
		}
		isThirsty = false;
	};
	void work() {
		std::this_thread::sleep_for(std::chrono::minutes(60));
		isThirsty = true;
		timeOfTheDay += 1;
	};
};

class Intern {
public:
	void FillGlass(Glass* glass) {
		glass->volume = glass->maxVolume;
	};
};

int main()
{
	User* user = new User();
	Glass* glass = new Glass();
	while (timeOfTheDay < 8)
	{
		if (!glass->isEmpty() && user->isThirsty) {
			user->Drink(glass);
		}
		else if (glass->isEmpty() && user->isThirsty)
		{
			Intern* intern = new Intern();
			intern->FillGlass(glass);
			delete intern;
		}
		user->work();
	};
	delete user;
	delete glass;
}
