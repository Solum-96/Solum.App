# FlutterFlow data schema

Mirrors `lib/data/models.dart` and the app state in `lib/state/solum_store.dart`.
Enum-like fields are Strings with the values listed (FlutterFlow Enums work
too; keep the same value names).

## Data Types

### Stop
A contact or address to visit. A stop with no `location` is a "No pin" contact:
it stays off the map and carousel.

| Field | Type | Notes |
|---|---|---|
| id | String | |
| location | LatLng (nullable) | null = no pin |
| street | String | "1544 SE Miller St" |
| name | String | equals `street` when unnamed |
| phone | String | |
| email | String | |
| note | String | "What to say" |
| state | String | `unvisited` · `visited` · `followUp` |
| due | String (nullable) | `overdue` · `today` · `week` |
| when | String (nullable) | "4pm", "Thu, 10am"; for overdue: the day it was due ("Sat") |
| order | Integer | hour of day for today (16 = 4pm); 100 for later |
| history | List<VisitEntry> | newest first |
| statusLine | String | "Visited Mon · not home" for unnamed visited stops |
| areaId | String (nullable) | |
| addedAt | DateTime (nullable) | sorts first under "Recent" |

### VisitEntry
| Field | Type |
|---|---|
| day | String ("Today", "Mon"…; production: DateTime `at`) |
| text | String ("Spoke with them · left a flyer") |

### Area
| Field | Type | Notes |
|---|---|---|
| id | String | |
| name | String | |
| polygon | List<LatLng> | corners in tap order |
| isSample | Boolean | walkthrough sample; replaced by the first saved area |

## App State (persisted where marked)

| Variable | Type | Persist | Default |
|---|---|---|---|
| stops | List<Stop> | yes | seed (49 contacts, see `lib/data/seed.dart`) |
| areas | List<Area> | yes | [Sellwood] |
| activeAreaId | String | yes | `sellwood` |
| plan | String `free`/`plus`/`pro` | yes | `free` |
| trialEndsAt | DateTime | yes | |
| autoRetry / autoText / autoWeekly | Boolean | yes | true / false / false |
| morningReminder | Boolean | yes | true |
| darkMode | Boolean | yes | false (system) |
| tourStep | Integer 0–4 | yes | 0 (set to 1 after sign-up) |
| mapFilter | String `all`/`followUps`/`notVisited` | no | `all` |
| selectedStopId | String | no | |
| contactSort | String `status`/`az`/`recent` | no | `status` |
| draftPolygon | List<LatLng> | no | [] |
| outlining / addMode | Boolean | no | false |

## Limits (placeholder, pending business sign-off)

| Plan | Areas | Contacts | Automations | Price |
|---|---|---|---|---|
| Free | 1 | 50 | 1 (retry not-home) | $0 |
| Plus | 5 | 500 | all | $8/mo or $72/yr |
| Pro | unlimited | unlimited | custom + CSV export | $16/mo or $144/yr |

Free users who hit a limit see the limit sheet first, never the paywall directly.

## Backend later

When a backend is added (Supabase or Firebase), map each Data Type to a table /
collection with the same fields plus `owner_id` and `updated_at`, and keep the
app offline-first (local write, background sync).
