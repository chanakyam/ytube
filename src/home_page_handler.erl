-module(home_page_handler).
-author("chanakyam@koderoom.com").

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
		{<<"text/html">>, welcome}	
	], Req, State}.

terminate(_Reason, _Req, _State) ->
	ok.

%% API
welcome(Req, State) ->
	Url = "http://api.contentapi.ws/videos?channel=world_news&limit=1&skip=0&format=long",
	% io:format("movies url: ~p~n",[Url]),
	{ok, "200", _, Response_mlb} = ibrowse:send_req(Url,[],get,[],[]),
	ResponseParams_mlb = jsx:decode(list_to_binary(Response_mlb)),	
	[Params] = proplists:get_value(<<"articles">>, ResponseParams_mlb),

	Popular_Videos_Url = "http://api.contentapi.ws/videos?channel=world_news&limit=3&skip=10&format=short",
	{ok, "200", _, Response_Popular_Videos} = ibrowse:send_req(Popular_Videos_Url,[],get,[],[]),
	ResponseParams_Popular_Videos = jsx:decode(list_to_binary(Response_Popular_Videos)),	
	PopularVideos = proplists:get_value(<<"articles">>, ResponseParams_Popular_Videos),

	More_Videos_Url = "http://api.contentapi.ws/videos?channel=world_news&limit=9&skip=1&format=short",
	{ok, "200", _, Response_More_Videos} = ibrowse:send_req(More_Videos_Url,[],get,[],[]),
	ResponseParams_More_Videos = jsx:decode(list_to_binary(Response_More_Videos)),	
	MoreVideos = proplists:get_value(<<"articles">>, ResponseParams_More_Videos),

	{ok, Body} = index_dtl:render([{<<"videoParam">>,Params},{<<"popularvideos">>,PopularVideos},{<<"morevideos">>,MoreVideos}]),
    {Body, Req, State}.
