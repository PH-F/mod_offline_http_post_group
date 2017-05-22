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
-export([mod_opt_type/1, muc_filter_message/5]).

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

-spec muc_filter_message(message(), mod_muc_room:state(), jid(), jid(), binary()) -> message().
muc_filter_message(Pkt, #state{config = Config} = MUCState, RoomJID, From, FromNick) ->
  [].
