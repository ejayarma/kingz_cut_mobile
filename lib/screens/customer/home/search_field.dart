TextField(
      controller: _searchController,
      onChanged: (value) {
        filterSearchResults(value);
      },
      decoration: InputDecoration(
        hintText: "Search invoices...",
        prefixIcon: const Icon(CupertinoIcons.search),
        suffixIcon: _searchController.text.isEmpty
            ? null
            : IconButton(
                onPressed: () {
                  _searchController.text = '';
                },
                icon: Icon(Icons.cancel)),
        fillColor: Theme.of(context).colorScheme.primary.withOpacity(.15),
      ),
    )
