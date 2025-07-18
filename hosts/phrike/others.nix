{ ... }:
{

  services.glance = {
    enable = true;
    settings.server.port = 9097;
    settings = {
      pages = [
        {
          name = "Home";
          columns = [
            {
              size = "small";
              widgets = [
                {
                  type = "search";
                  search-engine = "duckduckgo";
                  bangs = [
                    {
                      title = "YouTube";
                      shortcut = "!yt";
                      url = "https://www.youtube.com/results?search_query={QUERY}";
                    }
                  ];
                }
                { type = "calendar"; }
                {
                  type = "weather";
                  location = "Porto, Portugal";
                }
                {
                  type = "twitch-channels";
                  channels = [
                    "gamesdonequick"
                  ];
                }
              ];
            }
            {
              size = "full";
              widgets = [
                {
                  type = "group";
                  widgets = [
                    {
                      type = "hacker-news";
                      limit = 20;
                      collapse-after = 15;
                    }
                    {
                      type = "lobsters";
                      limit = 20;
                      collapse-after = 15;
                    }
                    {
                      type = "reddit";
                      subreddit = "primeiraliga";
                      limit = 20;
                      collapse-after = 15;
                    }
                    {
                      type = "reddit";
                      subreddit = "homelab";
                      limit = 20;
                      collapse-after = 15;
                    }
                  ];
                }
              ];
            }
            {
              size = "small";
              widgets = [
                {
                  type = "reddit";
                  subreddit = "soccer";
                  style = "vertical-cards";
                  limit = 5;
                }
                {
                  type = "server-stats";
                  servers = [
                    {
                      type = "local";
                      name = "Services";
                    }
                  ];
                }
              ];
            }
          ];
        }
      ];
    };
  };

  services.duplicati = {
    enable = true;
    interface = "10.200.0.185";
    parameters = ''
      --webservice-allowedhostnames=*
    '';
  };
}
