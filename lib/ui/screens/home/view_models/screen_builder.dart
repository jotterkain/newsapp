import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:newsapp/data/api/api.dart';
import 'package:newsapp/ui/screens/home/components/errors_widgets/api_error_widget.dart';
import 'package:newsapp/ui/screens/home/components/errors_widgets/no_internet_widget.dart';
import 'package:newsapp/ui/screens/home/components/loading_widget/loading_widget.dart';
import 'package:newsapp/ui/screens/home/view_models/feeds_builder.dart';
import 'package:newsapp/utils/enum.dart';
import 'package:provider/provider.dart';

ScrollController scrollController = ScrollController();

class ScreenBuilder extends StatefulWidget {
  const ScreenBuilder({Key? key}) : super(key: key);
  @override
  State<ScreenBuilder> createState() => _ScreenBuilderState();
}

class _ScreenBuilderState extends State<ScreenBuilder> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (Provider.of<NewsAPI>(context, listen: false).articles.isEmpty) {
        Provider.of<NewsAPI>(context, listen: false).fetchNewsByCategory();
      }
    });
    scrollController.addListener(() {
      if(mounted){
        /// if scroll til the end and data are not already loading
        if (scrollController.offset ==
            scrollController.position.maxScrollExtent && !Provider.of<NewsAPI>(context,listen: false).apiRequestStatus.isLoadingMore) {
          log("Scroll: maxScrollExtent reached");
          Provider.of<NewsAPI>(context, listen: false).loadMoreNews();
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      child: RefreshIndicator(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        color: Theme.of(context).primaryColor,
        onRefresh: () async {
          Provider.of<NewsAPI>(context, listen: false).fetchNewsByCategory();
          return Future(() => null);
        },
        child: _bodyBuilder(
            Provider.of<NewsAPI>(context, listen: true).apiRequestStatus),
      ),
    );
  }

  Widget _bodyBuilder(APIRequestStatus status) {
    if (status.isUninitialized) {
      return const ApiErrorWidget(search: false);
    }
    if (status.isLoading &&
        Provider.of<NewsAPI>(context, listen: false).articles.isEmpty) {
      return const LoadingWidget();
    }
    if (status.hasError) {
      return const ApiErrorWidget(search: false);
    }
    if (status.hasConnectionError){
      return const NoInternetErrorWidget();
    }
    /// else, data loaded
    return const Home();
  }
}

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const FeedsBuilder();
  }
}