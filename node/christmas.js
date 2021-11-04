'use strict';

const SaxonJS = require('saxon-js');

const DECEMBER = 11; // 0-based counting!

const today = new Date();
let year = today.getFullYear();

if (today.getMonth() == DECEMBER && today.getDate() >= 25) {
  year += 1;
}

let christmas = `${year}-12-25`;
let options = { "params": {"Q{}christmas": christmas} };

let days = SaxonJS.XPath.evaluate(
  `let $duration := xs:date($christmas) - current-date()
   return
     if ($duration <= xs:dayTimeDuration("P1D"))
     then 'Christmas is TOMORROW!'
     else 'It''s '
          || days-from-duration($duration)
          || ' days ''til Christmas'`,
  null, options);

console.log(days);
