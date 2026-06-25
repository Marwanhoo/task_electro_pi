import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_electro_pi/feature/movies/ui/widgets/movie_poster_card.dart';
import 'package:task_electro_pi/feature/search/viewmodel/search_cubit.dart';
import 'package:task_electro_pi/feature/search/viewmodel/search_state.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => SearchScreenState();
}

class SearchScreenState extends State<SearchScreen> {
  final TextEditingController searchTextController = TextEditingController();

  @override
  void dispose() {
    searchTextController.dispose();
    super.dispose();
  }

  void clearSearchQuery() {
    searchTextController.clear();
    context.read<SearchCubit>().onSearchQueryChanged('');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: searchTextController,
          autofocus: true,
          textInputAction: TextInputAction.search,
          onChanged: context.read<SearchCubit>().onSearchQueryChanged,
          decoration: InputDecoration(
            hintText: 'Search for a movie...',
            border: InputBorder.none,
            suffixIcon: ValueListenableBuilder<TextEditingValue>(
              valueListenable: searchTextController,
              builder: (builderContext, textValue, child) {
                if (textValue.text.isEmpty) {
                  return const SizedBox.shrink();
                }
                return IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: clearSearchQuery,
                );
              },
            ),
          ),
        ),
      ),
      body: BlocBuilder<SearchCubit, SearchState>(
        builder: (builderContext, state) => buildBody(state),
      ),
    );
  }

  Widget buildBody(SearchState state) {
    switch (state.status) {
      case SearchStatus.initial:
        return const SearchMessage(message: 'Search for your favorite movies');
      case SearchStatus.loading:
        return const Center(child: CircularProgressIndicator());
      case SearchStatus.empty:
        return SearchMessage(message: 'No results for "${state.query}"');
      case SearchStatus.failure:
        return SearchMessage(
          message: state.errorMessage ?? 'Something went wrong',
        );
      case SearchStatus.success:
        return buildResultsGrid(state);
    }
  }

  Widget buildResultsGrid(SearchState state) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 14,
        mainAxisSpacing: 18,
        childAspectRatio: 0.44,
      ),
      itemCount: state.results.length,
      itemBuilder: (gridContext, index) =>
          MoviePosterCard(
            movie: state.results[index],
            heroScope: 'search-$index',
          ),
    );
  }
}

class SearchMessage extends StatelessWidget {
  const SearchMessage({super.key, required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Text(
          message,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.titleMedium,
        ),
      ),
    );
  }
}
