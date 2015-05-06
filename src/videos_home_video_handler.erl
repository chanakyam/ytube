-module(videos_home_video_handler).
-author("shree@ybrantdigital.com").

-export([init/3]).

-export([content_types_provided/2]).
-export([welcome/2]).
-export([terminate/3]).

%% Init
init(_Transport, _Req, []) ->
	{upgrade, protocol, cowboy_rest}.

%% Callbacks
content_types_provided(Req, State) ->
	{[		
		{<<"application/json">>, welcome}	
	], Req, State}.

terminate(_Reason, _Req, _State) ->
	ok.

%% API
welcome(Req, State) ->
	{ok, "200", _, Response} = ibrowse:send_req("http://couchdb.speakglobally.net/speakglobally/_design/home_video/_view/by_id_title_video_path?descending=true&limit=20",[],get,[],[]),
	Res = string:sub_string(Response, 1, string:len(Response) -1 ),
	Params = jsx:decode(list_to_binary(Res)),
	{value, {<<"rows">>, RowsList }}= lists:keysearch(<<"rows">>,1, Params),
	RandomElement = random:uniform(19),
	RandomVideo = lists:nth(RandomElement, RowsList),
	lager:info("~p", [jsx:encode(RandomVideo)]),
	Body = jsx:encode(RandomVideo),
	{Body, Req, State}.


