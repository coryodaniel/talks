defmodule Affinity do
  @moduledoc """
  Toying around w/ CPU things.

  Questions:
    * [ ] Given `n`=number cores; measure performance impact when scheduler count is n/2, n, n*2, n^2
    * [ ] What info can be gathered from [`:sys`](http://erlang.org/doc/man/sys.html) module
    * [ ] Effects of different system flags `:erlang.system_flag/2`
      * :microstate_accounting, true
      * :dirty_cpu_schedulers_online
      * :dirty_cpu_schedulers
      * :dirty_io_schedulers
      * :schedulers
      * :schedulers_online
  """
end
