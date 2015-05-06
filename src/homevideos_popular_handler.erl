-module(homevideos_popular_handler).
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
	% lager:info("List of Popular videos requested"),
	{Count, _} = cowboy_req:qs_val(<<"n">>, Req),
	{Skip, _} = cowboy_req:qs_val(<<"skip">>, Req),
	
	Url = string:join(["http://contentapi.ws:5984/contentapi_video/_design/video_world_news/_view/full_composite_article?descending=true&limit=", binary_to_list(Count),"&skip=",binary_to_list(Skip)],""),
	{ok, "200", _, Response} = ibrowse:send_req(Url,[],get,[],[]),
	Res = string:sub_string(Response, 1, string:len(Response) -1 ),
	Body = list_to_binary(Res),
	{Body, Req, State}.


