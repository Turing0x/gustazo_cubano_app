Map<String, int> shoppingCart = {};

class ShoppingCart {

  void addToCar(String id){
    if(!shoppingCart.containsKey(id)){
      shoppingCart.addAll({
        id: 1 
      });
    }else{
      shoppingCart.update(id, (value) => value + 1);
    }
  }

  void lessToCar(String id){
    shoppingCart[id] = (shoppingCart[id] ?? 0) - 1;
  }

  String getCantOfProduct(String id){
    return (shoppingCart[id] ?? 0).toString();
  }

  showCar(){
    print(shoppingCart);
  }

}