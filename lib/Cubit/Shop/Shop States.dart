abstract class ShopStates{

}
class ShopInitialState extends ShopStates{}
class ShopChangeBottomNavState extends ShopStates{}

class ShopLoadingHomeDataState extends ShopStates{}
class ShopSuccessHomeDataState extends ShopStates{}
class ShopErrorHomeDataState extends ShopStates{}

class ShopSearchState extends ShopStates{}
class ShopSearchLoadingState extends ShopStates{}
class ShopProductsLoadedState extends ShopStates{}

class ShopLoadingCatProductsDataState extends ShopStates{}
class ShopSuccessCatProductsDataState extends ShopStates{}
class ShopErrorCatProductsDataState extends ShopStates{}

class GetFirebaseDataState extends ShopStates{}
class UserLoading extends ShopStates {}

// Success state with user data
class UserLoaded extends ShopStates {
  final Map<String, dynamic> userData;

  UserLoaded(this.userData);

  @override
  List<Object?> get props => [userData];
}

// Error state
class UserError extends ShopStates {
  final String error;

  UserError(this.error);

  @override
  List<Object?> get props => [error];
}
class ShopGetCategories extends ShopStates{

}
class ShopGetCategoriesSuccess extends ShopStates{

}
class ShopGetCategoriesError extends ShopStates{
}
class AddToCartSuccess extends ShopStates{}
class AddToCartError extends ShopStates{}

class GetCartData extends ShopStates{}
class GetCartDataSuccess extends ShopStates{}
class GetCartDataError extends ShopStates{}