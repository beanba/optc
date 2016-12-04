'use strict';

const _ = require('lodash');
const debug = require('debug')('optc');
const fs = require('fs');
const pug = require('pug');
const stringify = require('json-stable-stringify');

const regexpTest = function(pattern, o) {
  return pattern.test(o);
};

const indexJson = require('./index.json');

let langs = ['jp', 'tw', 'us'];
if (process.env.OPTC_LANG)
  langs = [process.env.OPTC_LANG];

if (process.env.OPTC_FORCE) {
  for (let i = 0; i < langs.length; i++) {
    const lang = langs[i];
    const files = fs.readdirSync(`png/${langs[i]}`);

    for (let j = 0; j < indexJson.builds.length; j++) {
      const build = indexJson.builds[j];

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

    const keys = ['name', 'portrait', 'skill', 'thumbnail', 'title'];
    const sortLangs = ['tw', 'jp', 'us'];

    for (let j = 0; j < indexJson.builds.length; j++) {
      const build = indexJson.builds[j];

      for (let k = 0; k < keys.length; k++) {
        const key = keys[k];

        for (let l = 0; l < sortLangs.length; l++) {
          const lang = sortLangs[l];

          if (build[key][lang] !== '' && !build[key][lang].endsWith('9999_t1.png') && !build[key][lang].endsWith('none.png')) {
            build[key].al = build[key][lang];
            break;
          }
        }
      }
    }
  }

  fs.writeFileSync('index.json', stringify(indexJson, {
    space: '  '
  }));
}

for (let i = 0; i < langs.length; i++) {
  const lang = langs[i];
  const compiledFunction = pug.compileFile(`index-${lang}.pug`, {
    pretty: true
  });

  fs.writeFileSync(`index-${lang}.html`, compiledFunction(indexJson));
}

const compiledFunction = pug.compileFile(`index.pug`, {
  pretty: true
});

fs.writeFileSync(`index.html`, compiledFunction(indexJson));