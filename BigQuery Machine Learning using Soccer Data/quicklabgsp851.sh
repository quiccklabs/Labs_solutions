



bq query --use_legacy_sql=false \
"
CREATE FUNCTION \`soccer.GetShotDistanceToGoal\`(x INT64, y INT64)
RETURNS FLOAT64
AS (
 SQRT(
   POW((100 - x) * 105/100, 2) +
   POW((50 - y) * 68/100, 2)
   )
 );
"

bq query --use_legacy_sql=false \
"
CREATE FUNCTION \`soccer.GetShotAngleToGoal\`(x INT64, y INT64)
RETURNS FLOAT64
AS (
 SAFE.ACOS(
   /* Have to translate 0-100 (x,y) coordinates to absolute positions using
   'average' field dimensions of 105x68 before using in various distance calcs */
   SAFE_DIVIDE(
     ( /* Squared distance between shot and 1 post, in meters */
       (POW(105 - (x * 105/100), 2) + POW(34 + (7.32/2) - (y * 68/100), 2)) +
       /* Squared distance between shot and other post, in meters */
       (POW(105 - (x * 105/100), 2) + POW(34 - (7.32/2) - (y * 68/100), 2)) -
       /* Squared length of goal opening, in meters */
       POW(7.32, 2)
     ),
     (2 *
       /* Distance between shot and 1 post, in meters */
       SQRT(POW(105 - (x * 105/100), 2) + POW(34 + 7.32/2 - (y * 68/100), 2)) *
       /* Distance between shot and other post, in meters */
       SQRT(POW(105 - (x * 105/100), 2) + POW(34 - 7.32/2 - (y * 68/100), 2))
     )
    )
  /* Translate radians to degrees */
  ) * 180 / ACOS(-1)
 )
;
"



bq query --use_legacy_sql=false \
"
CREATE MODEL \`soccer.xg_logistic_reg_model\`
OPTIONS(
 model_type = 'LOGISTIC_REG',
 input_label_cols = ['isGoal']
 ) AS

SELECT
 Events.subEventName AS shotType,

 /* 101 is known Tag for 'goals' from goals table */
 (101 IN UNNEST(Events.tags.id)) AS isGoal,

  \`soccer.GetShotDistanceToGoal\`(Events.positions[ORDINAL(1)].x,
   Events.positions[ORDINAL(1)].y) AS shotDistance,

 \`soccer.GetShotAngleToGoal\`(Events.positions[ORDINAL(1)].x,
   Events.positions[ORDINAL(1)].y) AS shotAngle

FROM
 \`soccer.events\` Events

LEFT JOIN
 \`soccer.matches\` Matches ON
   Events.matchId = Matches.wyId

LEFT JOIN
 \`soccer.competitions\` Competitions ON
   Matches.competitionId = Competitions.wyId

WHERE
 /* Filter out World Cup matches for model fitting purposes */
 Competitions.name != 'World Cup' AND
 /* Includes both 'open play' & free kick shots (including penalties) */
 (
   eventName = 'Shot' OR
   (eventName = 'Free Kick' AND subEventName IN ('Free kick shot', 'Penalty'))
 )
;
"



bq query --use_legacy_sql=false \
"
SELECT
 *
FROM
 ML.WEIGHTS(MODEL soccer.xg_logistic_reg_model)
;
"


bq query --use_legacy_sql=false \
"
CREATE MODEL \`soccer.xg_boosted_tree_model\`
OPTIONS(
 model_type = 'BOOSTED_TREE_CLASSIFIER',
 input_label_cols = ['isGoal']
 ) AS

SELECT
 Events.subEventName AS shotType,

 /* 101 is known Tag for 'goals' from goals table */
 (101 IN UNNEST(Events.tags.id)) AS isGoal,
  \`soccer.GetShotDistanceToGoal\`(Events.positions[ORDINAL(1)].x,
   Events.positions[ORDINAL(1)].y) AS shotDistance,

 \`soccer.GetShotAngleToGoal\`(Events.positions[ORDINAL(1)].x,
   Events.positions[ORDINAL(1)].y) AS shotAngle

FROM
 \`soccer.events\` Events

LEFT JOIN
 \`soccer.matches\` Matches ON
   Events.matchId = Matches.wyId

LEFT JOIN
 \`soccer.competitions\` Competitions ON
   Matches.competitionId = Competitions.wyId

WHERE
 /* Filter out World Cup matches for model fitting purposes */
 Competitions.name != 'World Cup' AND
 /* Includes both 'open play' & free kick shots (including penalties) */
 (
   eventName = 'Shot' OR
   (eventName = 'Free Kick' AND subEventName IN ('Free kick shot', 'Penalty'))
 )
;
"



bq query --use_legacy_sql=false \
"
SELECT
 *

FROM
 ML.PREDICT(
   MODEL \`soccer.xg_logistic_reg_model\`,
   (
     SELECT
       Events.subEventName AS shotType,

       /* 101 is known Tag for 'goals' from goals table */
       (101 IN UNNEST(Events.tags.id)) AS isGoal,

       \`soccer.GetShotDistanceToGoal\`(Events.positions[ORDINAL(1)].x,
           Events.positions[ORDINAL(1)].y) AS shotDistance,

       \`soccer.GetShotAngleToGoal\`(Events.positions[ORDINAL(1)].x,
           Events.positions[ORDINAL(1)].y) AS shotAngle

     FROM
       \`soccer.events\` Events

     LEFT JOIN
       \`soccer.matches\` Matches ON
           Events.matchId = Matches.wyId

     LEFT JOIN
       \`soccer.competitions\` Competitions ON
           Matches.competitionId = Competitions.wyId

     WHERE
       /* Look only at World Cup matches for model predictions */
       Competitions.name = 'World Cup' AND
       /* Includes both 'open play' & free kick shots (including penalties) */
       (
           eventName = 'Shot' OR
           (eventName = 'Free Kick' AND subEventName IN ('Free kick shot', 'Penalty'))
       )
   )
 )
"


bq query --use_legacy_sql=false \
"
SELECT
 predicted_isGoal_probs[ORDINAL(1)].prob AS predictedGoalProb,
 * EXCEPT (predicted_isGoal, predicted_isGoal_probs),

FROM
 ML.PREDICT(
   MODEL \`soccer.xg_logistic_reg_model\`,
   (
     SELECT
       Events.playerId,
       (Players.firstName || ' ' || Players.lastName) AS playerName,

       Teams.name AS teamName,
       CAST(Matches.dateutc AS DATE) AS matchDate,
       Matches.label AS match,

     /* Convert match period and event seconds to minute of match */
       CAST((CASE
         WHEN Events.matchPeriod = '1H' THEN 0
         WHEN Events.matchPeriod = '2H' THEN 45
         WHEN Events.matchPeriod = 'E1' THEN 90
         WHEN Events.matchPeriod = 'E2' THEN 105
         ELSE 120
         END) +
         CEILING(Events.eventSec / 60) AS INT64)
         AS matchMinute,

       Events.subEventName AS shotType,

       /* 101 is known Tag for 'goals' from goals table */
       (101 IN UNNEST(Events.tags.id)) AS isGoal,

       \`soccer.GetShotDistanceToGoal\`(Events.positions[ORDINAL(1)].x,
           Events.positions[ORDINAL(1)].y) AS shotDistance,

       \`soccer.GetShotAngleToGoal\`(Events.positions[ORDINAL(1)].x,
           Events.positions[ORDINAL(1)].y) AS shotAngle

     FROM
       \`soccer.events\` Events

     LEFT JOIN
       \`soccer.matches\` Matches ON
           Events.matchId = Matches.wyId

     LEFT JOIN
       \`soccer.competitions\` Competitions ON
           Matches.competitionId = Competitions.wyId

     LEFT JOIN
       \`soccer.players\` Players ON
           Events.playerId = Players.wyId

     LEFT JOIN
       \`soccer.teams\` Teams ON
           Events.teamId = Teams.wyId

     WHERE
       /* Look only at World Cup matches to apply model */
       Competitions.name = 'World Cup' AND
       /* Includes both 'open play' & free kick shots (but not penalties) */
       (
         eventName = 'Shot' OR
         (eventName = 'Free Kick' AND subEventName IN ('Free kick shot'))
       ) AND
       /* Filter only to goals scored */
       (101 IN UNNEST(Events.tags.id))
   )
 )

ORDER BY
  predictedgoalProb
"
