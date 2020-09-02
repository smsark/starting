import 'package:compound/ui/shared/ui_helpers.dart';
import 'package:compound/ui/widgets/creation_aware_list_item.dart';
import 'package:compound/ui/widgets/post_item.dart';
import 'package:compound/constants/route_names.dart' as routes;
import 'package:compound/viewmodels/home_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider_architecture/provider_architecture.dart';

class HomeView extends StatelessWidget {
  const HomeView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelProvider<HomeViewModel>.withConsumer(
        viewModel: HomeViewModel(),
        onModelReady: (model) => model.listenToUser(),
        builder: (context, model, child) => Scaffold(
              backgroundColor: Colors.white,
              appBar: AppBar(
                title: Text("تجارب", style: TextStyle(color: Colors.white),),
                centerTitle: true,
                automaticallyImplyLeading: false,
              ),
              // floatingActionButton: FloatingActionButton(
              //   backgroundColor: Theme.of(context).primaryColor,
              //   child: !model.busy
              //       ? Icon(Icons.add)
              //       : Center(child: CircularProgressIndicator()),
              //   onPressed: model.navigateToCreateView,
              // ),
              body: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    verticalSpace(35),
                    Row(
                      children: <Widget>[
                        SizedBox(
                          height: 20,
                          child: Image.asset('assets/images/title.png'),
                        ),
                      ],
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          Text("Full Name: ${model.user.fullName}", style: TextStyle(color: Colors.blueAccent),),
                          Text("E-mail: ${model.user.email}", style: TextStyle(color: Colors.blueAccent),),
                          FlatButton.icon(
                              onPressed: ()=> model.navigateTo(routes.ShowAdsViewRoute),
                              icon: Icon(Icons.add_shopping_cart,color: Colors.orange,),
                              label: Text("Go to ads",style: TextStyle(color: Colors.orange)),
                          )
                        ],
                      ),
                    ),
                    /*Expanded(
                        child: model.posts != null
                            ? ListView.builder(
                                itemCount: model.posts.length,
                                itemBuilder: (context, index) =>
                                    CreationAwareListItem(
                                  itemCreated: () {
                                    if (index % 20 == 0)
                                      model.requestMoreData();
                                  },
                                  child: GestureDetector(
                                    onTap: () => model.editPost(index),
                                    child: PostItem(
                                      post: model.posts[index],
                                      onDeleteItem: () =>
                                          model.deletePost(index),
                                    ),
                                  ),
                                ),
                              )
                            : Center(
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation(
                                      Theme.of(context).primaryColor),
                                ),
                              ))*/
                  ],
                ),
              ),
            ));
  }
}
