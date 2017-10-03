%%%-------------------------------------------------------------------
%%% @author Patrick Houtman
%%% @doc
%%%
%%% @end
%%% Created : 15. May 2017 16:50
%%%-------------------------------------------------------------------
-module(mod_offline_http_post_group).
-author("Patrick Houtman").

-behaviour(gen_mod).

-export([start/2, stop/1, depends/2]).
-export([mod_opt_type/1, muc_filter_message/3]).

-include("xmpp.hrl").
-include("logger.hrl").
-include("ejabberd.hrl").

%% Are all 3 required?
-include("mod_muc_room.hrl").
-include("ejabberd_commands.hrl").
-include("mod_mam.hrl").

start(_Host, _Opt) ->
  ?INFO_MSG("mod_offline_http_post_group loading", []),
  inets:start(),
  ?INFO_MSG("HTTP client started", []),
  ejabberd_hooks:add(muc_filter_message, _Host, ?MODULE, muc_filter_message, 50).

stop(_Host) ->
  ?INFO_MSG("stopping mod_offline_http_post_group", []),
  ejabberd_hooks:delete(muc_filter_message, _Host, ?MODULE, muc_filter_message, 50).

depends(_Host, _Opts) ->
  [].

mod_opt_type(_) ->
  [].

-spec muc_filter_message(message(), mod_muc_room:state(), binary()) -> message().

muc_filter_message(Pkt, #state{config = Config, jid = RoomJID} = MUCState, FromNick) ->
  From = xmpp:get_from(Pkt),
  ?INFO_MSG("muc_filter_message called.", []).

%% loop through room members
%% if is-offline
%% post_offline_message(From, _To, Body, Packet#message.id);
%% end..



%%post_offline_message(From, To, Body, MessageId) ->
%%  Token = gen_mod:get_module_opt(To#jid.lserver, ?MODULE, auth_token, fun(S) -> iolist_to_binary(S) end, list_to_binary("")),
%%  PostUrl = gen_mod:get_module_opt(To#jid.lserver, ?MODULE, post_url, fun(S) -> iolist_to_binary(S) end, list_to_binary("")),
%%  ToUser = To#jid.luser,
%%  FromUser = From#jid.luser,
%%  Vhost = To#jid.lserver,
%%  Data = string:join(["to=", binary_to_list(ToUser), "&from=", binary_to_list(FromUser), "&vhost=", binary_to_list(Vhost), "&body=", binary_to_list(Body), "&messageId=", binary_to_list(MessageId)], ""),
%%  Request = {binary_to_list(PostUrl), [{"Authorization", binary_to_list(Token)}], "application/x-www-form-urlencoded", Data},
%%  httpc:request(post, Request,[],[]),
%%  ?INFO_MSG("post request sent", []).