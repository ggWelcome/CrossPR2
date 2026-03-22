import 'dart:io';

// Абстрактний клас EnergySource використовується як інтерфейс.
// Він задає контракт: будь-яке джерело енергії повинно мати метод generateEnergy()
// та властивість type (тип джерела).
abstract class EnergySource {
  double generateEnergy(); // метод для генерації енергії
  String get type;         // тип джерела
}

// Клас SolarPanel реалізує інтерфейс EnergySource.
// Він моделює сонячну панель, яка має потужність (capacity).
class SolarPanel implements EnergySource {
  double _capacity; // приватне поле, що зберігає потужність панелі

  // Конструктор для створення сонячної панелі з певною потужністю
  SolarPanel(this._capacity);

  // Гетер для доступу до потужності
  double get capacity => _capacity;

  // Сетер для зміни потужності з перевіркою коректності
  set capacity(double value) {
    if (value > 0) {
      _capacity = value;
    } else {
      print("Потужність сонячної панелі має бути додатною!");
    }
  }

  // Реалізація методу generateEnergy з інтерфейсу
  @override
  double generateEnergy() {
    // Умовно вважаємо, що панель генерує 80% від своєї потужності
    return _capacity * 0.8;
  }

  // Реалізація властивості type
  @override
  String get type => "Solar";
}

// Клас ThermalGenerator реалізує інтерфейс EnergySource.
// Він моделює тепловий генератор, який виробляє енергію з палива.
class ThermalGenerator implements EnergySource {
  double _fuelEnergy; // приватне поле — запас енергії палива

  // Конструктор
  ThermalGenerator(this._fuelEnergy);

  // Гетер для доступу до запасу енергії
  double get fuelEnergy => _fuelEnergy;

  // Сетер для зміни запасу енергії з перевіркою
  set fuelEnergy(double value) {
    if (value >= 0) {
      _fuelEnergy = value;
    } else {
      print("Енергія палива не може бути від’ємною!");
    }
  }

  // Реалізація методу generateEnergy
  @override
  double generateEnergy() {
    // Умовно: ККД теплового генератора = 60%
    return _fuelEnergy * 0.6;
  }

  // Реалізація властивості type
  @override
  String get type => "Thermal";
}

// Базовий клас Device моделює споживач енергії (наприклад, побутовий прилад).
class Device {
  String name;   // назва пристрою
  double _power; // приватне поле — потужність (Вт)
  double _hours; // приватне поле — час роботи (год)

  // Конструктор
  Device(this.name, this._power, this._hours);

  // Гетери для доступу до значень
  double get power => _power;
  double get hours => _hours;

  // Сетери для зміни значень з перевіркою
  set power(double value) {
    if (value > 0) {
      _power = value;
    } else {
      print("Потужність має бути додатною!");
    }
  }

  set hours(double value) {
    if (value >= 0) {
      _hours = value;
    } else {
      print("Час роботи не може бути від’ємним!");
    }
  }

  // Метод для розрахунку добового споживання пристрою
  double getConsumption() {
    return _power * _hours; // Вт * год = Вт·год
  }
}

// Клас SmartGrid моделює систему розподілу енергії.
// Він управляє списком пристроїв та джерел енергії, а також виконує балансування.
class SmartGrid {
  List<Device> devices = [];        // список пристроїв
  List<EnergySource> sources = [];  // список джерел енергії

  // Метод для додавання пристрою
  void addDevice(Device device) {
    devices.add(device);
  }

  // Метод для додавання джерела енергії
  void addSource(EnergySource source) {
    sources.add(source);
  }

  // Метод для балансування енергії: порівнює споживання та генерацію
  void balanceEnergy() {
    // Обчислюємо загальне споживання
    double totalConsumption = devices.fold(0, (sum, d) => sum + d.getConsumption());

    // Обчислюємо загальну генерацію
    double totalGenerated = sources.fold(0, (sum, s) => sum + s.generateEnergy());

    // Виводимо звіт
    print("\n=== Smart Grid Report ===");
    print("Загальне споживання: $totalConsumption Вт·год");
    print("Загальна генерація: $totalGenerated Вт·год");

    // Умова для перевірки балансу
    if (totalGenerated >= totalConsumption) {
      print("Система збалансована: вистачає енергії для всіх пристроїв.");
    } else {
      print("Дефіцит енергії: потрібно оптимізувати або додати джерела.");
    }
  }
}

void main() {
  // Створюємо об’єкт SmartGrid (система розподілу енергії)
  SmartGrid grid = SmartGrid();

  // Створюємо об’єкти джерел енергії
  SolarPanel solar = SolarPanel(3000);          // сонячна панель
  ThermalGenerator thermal = ThermalGenerator(5000); // тепловий генератор

  // Використовуємо сетери для зміни параметрів джерел
  solar.capacity = 3500;       // оновили потужність сонячної панелі
  thermal.fuelEnergy = 6000;   // оновили запас енергії палива

  // Додаємо джерела у систему SmartGrid
  grid.addSource(solar);
  grid.addSource(thermal);

  // Введення кількості пристроїв від користувача
  stdout.write("Введіть кількість пристроїв: ");
  int deviceCount = int.parse(stdin.readLineSync()!);

  // Цикл для введення даних про кожен пристрій
  for (int i = 1; i <= deviceCount; i++) {
    stdout.write("\nНазва пристрою $i: ");
    String name = stdin.readLineSync()!;

    stdout.write("Потужність (Вт): ");
    double power = double.parse(stdin.readLineSync()!);

    stdout.write("Час роботи (год): ");
    double hours = double.parse(stdin.readLineSync()!);

    // Створюємо об’єкт пристрою
    Device device = Device(name, power, hours);

    // Додаємо пристрій у SmartGrid
    grid.addDevice(device);
  }

  // Виконуємо балансування системи
  grid.balanceEnergy();
}
