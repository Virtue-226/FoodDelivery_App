import 'dart:convert';
import 'dart:io';

import 'package:fooddelivery_app/src/models/food_model.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class FoodModel extends Model {
  bool _isLoading = false;
  List<Food> _foods = [];
  List<Food> _cartList = [];
  List<Food> food = [];
  int counter = 0;
  double val = 0;
  double price;
  double discount;


  List<File> _image = [];
  final picker = ImagePicker();

  File get foodImage {
    return _image[counter++];
  }

  bool get isLoading {
    return _isLoading;
  }

  List<Food> get foods {
    return List.from(_foods);
  }

  List<Food> get cartlists {
    return List.from(_cartList);
  }

  int get foodLength {
    return _foods.length;
  }

  int get foodaLength {
    return food.length;
  }

  Future<bool> addFood(Food food) async {
    // _foods.add(food);
    _isLoading = true;
    notifyListeners();
    try {
      final Map<String, dynamic> ForData = {
        "title": food.name,
        "imagePath": food.imagePath,
        "description": food.description,
        "category": food.category,
        "price": food.prices,
        "discount": food.discount,
      };
      final http.Response response = await http.post(
          Uri.parse(
              "https://foodey3-e0880-default-rtdb.firebaseio.com/foods.json"),
          body: json.encode(ForData));
      // print(response);
      final Map<String, dynamic> responseData = json.decode(response.body);
      // print(responseData["name"]);
      Food foodWithID = Food(
        id: responseData["name"],
        name: food.name,
        imagePath: food.imagePath,
        // prices: food.prices,
        description: food.description,
        category: food.category,
        discount: food.discount,
        prices: food.prices,
      );
      _foods.add(foodWithID);
      _isLoading = false;
      notifyListeners();
      // fetchFoods();
      return Future.value(true);
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return Future.value(false);
      // print("connection error: $e");
    }

    // _foods.add(foodWithID);
  }

  Future<bool> fetchFoods() async {
    try {
      final http.Response response = await http.get(Uri.parse(
          "https://foodey3-e0880-default-rtdb.firebaseio.com/foods.json"));

      // print("Fetching data : ${response.body}");
      final Map<String, dynamic> fetchedData = json.decode(response.body);
      // print(fetchedData);
      final List<Food> fetchedFoodItems = [];

      fetchedData.forEach((String id, dynamic foodData) {
        Food foodItem = Food(
          id: id,
          name: foodData["title"],
          // imagePath: foodData["imagePath"],
          description: foodData["description"],
          category: foodData["category"],
          prices: double.parse(foodData["price"].toString()),
          discount: double.parse(foodData["discount"].toString()),
        );
        fetchedFoodItems.add(foodItem);

        _foods = fetchedFoodItems;
        // _cartList = _foods;
        _isLoading = false;
        notifyListeners();
        return Future.value(true);
      });
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return Future.value(false);
    }
    return null;
  }

  Future<bool> fetchFood() async {
    try {
      final http.Response response = await http.get(Uri.parse(
          "https://foodey3-e0880-default-rtdb.firebaseio.com/foods.json"));

      // print("Fetching data : ${response.body}");
      final Map<String, dynamic> fetchedAData = json.decode(response.body);
      // print(fetchedData);
      final List<Food> fetchedAFood = [];

      fetchedAData.forEach((String id, dynamic foodAData) {
        Food foodAItem = Food(
          id: id,
          name: foodAData["title"],
          // imagePath: foodData["imagePath"],
          description: foodAData["description"],
          category: foodAData["category"],
          prices: double.parse(foodAData["price"].toString()),
          discount: double.parse(foodAData["discount"].toString()),
        );
        fetchedAFood.add(foodAItem);

        food = fetchedAFood;
        // _cartList = _foods;
        _isLoading = false;
        notifyListeners();
        return Future.value(true);
      });
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return Future.value(false);
    }
    return null;
  }

  Future<bool> updateFood(Map<String, dynamic> foodData, String foodId) async {
    _isLoading = true;
    notifyListeners();
    //get the food by id
    Food thefood = getFoodItemById(foodId);
    //get food index of the food
    int foodIndex = _foods.indexOf(thefood);
    try {
      await http.put(
          Uri.parse(
              "https://foodey3-e0880-default-rtdb.firebaseio.com/${foodId}.json"),
          body: json.encode(foodData));
      Food updateFoodItem = Food(
        id: foodId,
        name: foodData["title"],
        // imagePath: foodData["imagePath"],
        category: foodData["category"],
        discount: foodData["discount"],
        prices: foodData["price"],
        description: foodData["description"],
      );
      _foods[foodIndex] = updateFoodItem;
      // _cartList[foodIndex] = _foods[foodIndex];

      _isLoading = false;
      notifyListeners();
      return Future.value(true);
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return Future.value(false);
    }
  }

  Food getFoodItemById(String foodId) {
    Food food;
    for (int i = 0; i <= _foods.length; i++) {
      food = _foods[i];
      break;
    }
    return food;
  }

  double totalPrice() {
    for (int j = 0; j <= _cartList.length; j++) {
      price = _cartList[j].prices;
      break;
    }
    return price;
  }

  double totalDiscount() {
    for (int k = 0; k <= _cartList.length; k++) {
      discount = _cartList[k].discount;
      break;
    }
    return discount;
  }
  

  addToCart(Food food) {
    _cartList.add(food);

    counter++;
    notifyListeners();
  }

  void removeToCart(Food food) {
    _cartList.remove(food);
    counter--;

    notifyListeners();
  }

  get foodleng {
    return _cartList.length;
  }

  // List<Food> get basketItem {
  //   return _cartList;
  // }
  // chooseImage() async {
  //   _isLoading = true;
  //   notifyListeners();
  //   final pickedFile = await picker.getImage(source: ImageSource.gallery);

  //   _image.add(File(pickedFile?.path));

  //   if (pickedFile.path == null) retrieveLostData();
  //   _isLoading = false;
  //   notifyListeners();
  // }

  // Future<void> retrieveLostData() async {
  //   _isLoading = true;
  //   notifyListeners();
  //   final LostData response = await picker.getLostData();
  //   if (response.isEmpty) {
  //     return;
  //   }
  //   if (response.file != null) {
  //     _image.add(File(response.file.path));
  //   } else {
  //     print(response.file);
  //   }
  //   _isLoading = false;
  //   notifyListeners();
  // }

}
