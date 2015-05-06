-module(ytube_app).
-author("shree@ybrantdigital.com").

-behaviour(application).

%% Application callbacks
-export([start/2, stop/1]).

%% ===================================================================
%% Application callbacks
%% ===================================================================

start(_StartType, _StartArgs) ->
	Dispatch = cowboy_router:compile([
		{'_',[
                {"/", home_page_handler, []},
				{"/api/home", site_root_handler, []},			                
                {"/api/videos/featured_none", videos_non_featured_handler, []},
                {"/api/videos/home_video", videos_home_video_handler, []}, 
				{"/api/videos/popular", videos_popular_handler, []},
                {"/api/homevideos/popular", homevideos_popular_handler, []},
				{"/api/videos/most_watched", videos_most_watched_handler, []},
				{"/api/videos/top_rated", videos_top_rated_handler, []},
                {"/api/videos/latest", videos_latest_handler, []},
                {"/api/videos/latest_one", videos_latest_one_handler, []},
                {"/api/videos/count", video_count_handler, []},
                {"/api/videos/single_video/:id", videos_single_video_handler, []},
                {"/pages", pagination_handler,[]},
                {"/terms", tnc_handler,[]},
                {"/about", about_handler,[]},
                {"/contact", contact_handler,[]},
                {"/privacy", privacy_handler,[]},
                {"/v/:id", video_page_handler, []},
				{"/css/[...]", cowboy_static, 
					[
                		{directory, {priv_dir, ytube, ["public/css"]}},
                		{mimetypes, {fun mimetypes:path_to_mimes/2, default}}
            		]
            	},
                {"/fonts/[...]", cowboy_static, 
                    [
                        {directory, {priv_dir, ytube, ["public/fonts"]}},
                        {mimetypes, {fun mimetypes:path_to_mimes/2, default}}
                    ]
                },
                {"/images/[...]", cowboy_static, 
                    [
                        {directory, {priv_dir, ytube, ["public/images"]}},
                        {mimetypes, {fun mimetypes:path_to_mimes/2, default}}
                    ]
                },
                
            	{"/js/[...]", cowboy_static, 
            		[
                		{directory, {priv_dir, ytube, ["public/js"]}},
                		{mimetypes, {fun mimetypes:path_to_mimes/2, default}}
            		]
            	},
            	
                {"/players/[...]", cowboy_static, 
                    [
                        {directory, {priv_dir, ytube, ["public/players"]}},
                        {mimetypes, {fun mimetypes:path_to_mimes/2, default}}
                    ]
                },
            	% {"/", cowboy_static, 
            	% 	[
             %    		{directory, {priv_dir, ytube, ["public"]}},
             %    		{file, "home.html"},
             %    		{mimetypes, {fun mimetypes:path_to_mimes/2, default}}
            	% 	]
            	% },
                % {"/about", cowboy_static, 
                %     [
                %         {directory, {priv_dir, ytube, ["public"]}},
                %         {file, "about.html"},
                %         {mimetypes, {fun mimetypes:path_to_mimes/2, default}}
                %     ]
                % },
                % {"/contact", cowboy_static, 
                %     [
                %         {directory, {priv_dir, ytube, ["public"]}},
                %         {file, "contact.html"},
                %         {mimetypes, {fun mimetypes:path_to_mimes/2, default}}
                %     ]
                % },
                % {"/privacy", cowboy_static, 
                %     [
                %         {directory, {priv_dir, ytube, ["public"]}},
                %         {file, "privacy.html"},
                %         {mimetypes, {fun mimetypes:path_to_mimes/2, default}}
                %     ]
                % },
                % {"/terms", cowboy_static, 
                %     [
                %         {directory, {priv_dir, ytube, ["public"]}},
                %         {file, "terms.html"},
                %         {mimetypes, {fun mimetypes:path_to_mimes/2, default}}
                %     ]
                % },
                {"/testng", cowboy_static, 
                    [
                        {directory, {priv_dir, ytube, ["public"]}},
                        {file, "testng.html"},
                        {mimetypes, {fun mimetypes:path_to_mimes/2, default}}
                    ]
                }
                
			 ]
		}

	]), 
    ok = application:start(lager),
    ok = application:start(crypto),
    ok = application:start(jsx),
    ok = application:start(ranch),
    ok = application:start(cowboy),
    ok = application:start(ibrowse),
    %ok = application:start(ytube),

	{ok, _} = cowboy:start_http(http,100, [{port, 8900}],[{env, [{dispatch, Dispatch}]},
                                                          {onrequest, fun request_hook_responder:set_cors/1},
                                                          {onresponse, fun error_hook_responder:respond/4}
              ]), 
    ytube_sup:start_link().

stop(_State) ->
    ok.
