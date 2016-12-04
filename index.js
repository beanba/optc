'use strict';

const _ = require('lodash');
const debug = require('debug')('optc');
const fs = require('fs');
const pug = require('pug');
const stringify = require('json-stable-stringify');

// const indexJson = require('./index.json');

// const newIndexJson = {
//   builds: []
// };

// for (let i = 0; i < indexJson.builds.length; i++) {
//   const old_build = indexJson.builds[i];

//   const new_build = {};
//   new_build.id = old_build.id;
//   new_build.name = {};
//   new_build.name.al = old_build['name'];
//   new_build.name.jp = old_build['name-jp'];
//   new_build.name.tw = old_build['name-tw'];
//   new_build.name.us = old_build['name-us'];
//   new_build.no = old_build.no;
//   new_build.portrait = {};
//   new_build.portrait.al = old_build['portrait'];
//   new_build.portrait.jp = old_build['portrait-jp'];
//   new_build.portrait.tw = old_build['portrait-tw'];
//   new_build.portrait.us = old_build['portrait-us'];
//   new_build.sid = old_build.sid;
//   new_build.skill = {};
//   new_build.skill.al = old_build['skill'];
//   new_build.skill.jp = old_build['skill-jp'];
//   new_build.skill.tw = old_build['skill-tw'];
//   new_build.skill.us = old_build['skill-us'];
//   new_build.thumbnail = {};
//   new_build.thumbnail.al = old_build['thumbnail'];
//   new_build.thumbnail.jp = old_build['thumbnail-jp'];
//   new_build.thumbnail.tw = old_build['thumbnail-tw'];
//   new_build.thumbnail.us = old_build['thumbnail-us'];
//   new_build.title = {};
//   new_build.title.al = old_build['title'];
//   new_build.title.jp = old_build['title-jp'];
//   new_build.title.tw = old_build['title-tw'];
//   new_build.title.us = old_build['title-us'];

//   newIndexJson.builds.push(new_build);
// }

// fs.writeFileSync('new-index.json', stringify(newIndexJson, {
//   space: '  '
// }));

const regexpTest = function(pattern, o) {
  return pattern.test(o);
};

const newIndexJson = require('./new-index.json');

let langs = ['jp', 'tw', 'us'];
if (process.env.OPTC_LANG)
  langs = [process.env.OPTC_LANG];

if (process.env.OPTC_FORCE) {
  for (let i = 0; i < langs.length; i++) {
    const lang = langs[i];
    const files = fs.readdirSync(`png/${langs[i]}`);

    // for (let j = 0; j < 1; j++) { // mocking
    for (let j = 0; j < newIndexJson.builds.length; j++) {
      const build = newIndexJson.builds[j];

      if (build.id === 9999 || build.name[lang] === '')
        continue;

      const portrait = build.portrait[lang];
      const skill = build.skill[lang];
      const thumbnail = build.thumbnail[lang];

      debug(build.no);

      if (portrait === `png/${lang}/character_9999_t1.png`) {
        debug('\x1b[33m', 'missing portrait', '\x1b[0m');
        const findName = `character_${_.padStart(build.id, 4, '0')}_c1.png`;
        if (files.includes(findName)) {
          debug('\x1b[93m', `found ${findName}`, '\x1b[0m');
          build.portrait[lang] = `png/${lang}/${findName}`;
        }
      }

      if (build.sid !== -1) {
        if (skill === `png/${lang}/character_9999_t1.png`) {
          debug('\x1b[32m', 'missing skill', '\x1b[0m');

          if (build.sid < 8000) { // skill with animation
            const pattern = new RegExp(`motion_${_.padStart(build.sid, 4, '0')}_.*_name\.png`);
            const findName = _.find(files, regexpTest.bind(null, pattern));

            if (findName) {
              debug('\x1b[92m', `found ${findName}`, '\x1b[0m');
              build.skill[lang] = `png/${lang}/${findName}`;
            } // skip law and ryu-ma case
          } else { // skill with only text
            const pattern = new RegExp(`skill_name_${_.padStart(build.sid, 4, '0')}\.png`);
            const findName = _.find(files, regexpTest.bind(null, pattern));

            if (findName) {
              debug('\x1b[92m', `found ${findName}`, '\x1b[0m');
              build.skill[lang] = `png/${lang}/${findName}`;
            }
          }
        }
      }

      if (thumbnail === `png/${lang}/character_none.png`) {
        debug('\x1b[31m', 'missing thumbnail', '\x1b[0m');
        const findName = `character_${_.padStart(build.id, 4, '0')}_t1.png`;
        if (files.includes(findName)) {
          debug('\x1b[91m', `found ${findName}`, '\x1b[0m');
          build.thumbnail[lang] = `png/${lang}/${findName}`;
        }
      }
    }
  }

  fs.writeFileSync('new-index.json', stringify(newIndexJson, {
    space: '  '
  }));
}

for (let i = 0; i < langs.length; i++) {
  const lang = langs[i];
  const compiledFunction = pug.compileFile(`new-index-${lang}.pug`, {
    pretty: true
  });

  fs.writeFileSync(`new-index-${lang}.html`, compiledFunction(newIndexJson));
}

const compiledFunction = pug.compileFile(`new-index.pug`, {
  pretty: true
});

fs.writeFileSync(`new-index.html`, compiledFunction(newIndexJson));