export const fetchSearchGiphys = searchTerm => (
    $.ajax({
        method: 'GET',
        url: `http://api.giphy.com/v1/gifs/search?q=${searchTerm}&api_key=LNZnNAwc4uXfQi7QXg5aVptrVxc87FCT&limit=2`
    })
);

// 