::  %live: event coordination
::    version ~2024.4.12
::    ~polrel-witter
::
/+  *mip
::
|%
::  $id: event identifier
::
+$  id  [=ship name=term]
::  +timezone: GMT zone
::
+$  timezone  (pair ? @ud)
::  $moment: event duration
::
+$  moment  [start=(unit time) end=(unit time) =timezone]
::  $kind: event type
::
::    %public: discoverable and open to anyone
::    %private: discoverable but restricted to approval and invite-only
::    %secret: non-discoverable and restricted to invite-only
::
+$  kind  ?(%public %private %secret)
::  $latch: acceptance status of an event
::
::    %open: actively accepting registrants
::    %closed: not accepting registrants; still receive requests
::    %over: inactive, non-discoverable
::
+$  latch  ?(%open %closed %over)
::  $talk: single event component
+$  talk
  $:  title=cord
      speaker=cord
      about=(unit cord)
      =moment
  ==
::  $info: public metadata for an event
::
+$  info
  $:  title=cord
      about=(unit cord)
      =moment
      =kind
      =latch
  ==
+$  info-1
  $:  title=cord
      about=(unit cord)
      =moment
      =kind
      =latch
      talks=(list talk)
  ==
::  $limit: number of ships that can register per event
::
+$  limit  (unit @ud)
::  $secret: some message reserved for %registered and %attended guests
::
+$  secret  (unit cord)
::  $event: event info controlled by host ship
::
+$  event    [=info =secret =limit]
+$  event-1  [info=info-1 =secret =limit]
::  $status: state of a guest
::
+$  status
  %+  pair
    $?  %invited
        %requested
        %registered
        %unregistered
        %attended
    ==
  time
::  $record: guest information
::
+$  record    [=info =secret =status]
+$  record-1  [info=info-1 =secret =status]
::  $dial: non-event-specific actions
::
+$  dial
  $%  [%find =ship name=(unit term)]            :: search for external events
      :: TODO these are a workaround until a path's "latest" revision number
      :: can be remote scried (i.e. /=/some/path)
      [%case-request name=(unit term)]
      [%case-response case=(unit @ud) name=(unit term)]
  ==
::  $sub-info: modify event info; slotted into an %info action
::
+$  sub-info
  $%  [%title title=cord]
      [%about about=(unit cord)]
      [%moment =moment]
      [%kind =kind]
      [%latch =latch]
  ==
+$  sub-info-1
  $%  [%title title=cord]
      [%about about=(unit cord)]
      [%moment =moment]
      [%kind =kind]
      [%latch =latch]
      [%talks talks=(list talk)]
  ==
::  $action: event api
::
+$  action
  $%  [%create =event-1]                       :: create an event
      [%delete ~]                            :: delete an event
      [%info =sub-info]                      :: change event info
      [%secret =secret]                      :: change event secret
      [%limit =limit]                        :: change event limit
    ::
      [%subscribe ~]                         :: subscribe to record updates
      [%invite ships=(list ship)]            :: invite ships to an event
      [%register who=(unit ship)]            :: register to an event
      [%unregister who=(unit ship)]          :: unregister from an event
      [%punch ?(%verify %revoke) =ship]      :: validate or revoke attendance
  ==
::  $operation: act on an event
::
+$  operation  [=id =action]
::  $demand: scry api
::
+$  demand
  $%  [%event-exists p=?]                    :: does an event exist?
      [%record-exists p=?]                   :: does a record exist?
      [%event p=(unit event-1)]                :: an event
      [%record p=(unit record-1)]              :: a record
      [%counts p=(map _-.status @ud)]        :: record status counts
      [%all-events p=(map id event-1)]         :: all events
      [%all-records p=(mip id ship record-1)]  :: all records
      [%event-records p=(map ship record-1)]   :: all records for an event
      [%remote-events p=(map id info-1)]     :: remote scry discoverable events
  ==
--
