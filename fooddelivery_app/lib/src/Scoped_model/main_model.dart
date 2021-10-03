import 'package:fooddelivery_app/src/Scoped_model/food_model.dart';
import 'package:fooddelivery_app/src/Scoped_model/user_scoped_model.dart';
import 'package:scoped_model/scoped_model.dart';

class MainModel extends Model with FoodModel,UserModel{
//This is a Mixin Class.

void fetchAll(){
  fetchFoods();
  fetchedUserInfo();
}
}