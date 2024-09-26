const fs = require('fs');
// const fetch = require('node-fetch');
const childproc = require("child_process");
const exec = childproc.exec;
const spawn = childproc.spawn;
const os = require('os');

const getArgs = () =>
  process.argv.reduce((args, arg) => {
    // long arg
    if (arg.slice(0, 2) === "--") {
      const longArg = arg.split("=");
      const longArgFlag = longArg[0].slice(2);
      const longArgValue = longArg.length > 1 ? longArg[1] : true;
      args[longArgFlag] = longArgValue;
    }
    // flags
    else if (arg[0] === "-") {
      const flags = arg.slice(1).split("");
      flags.forEach((flag) => {
        args[flag] = true;
      });
    }
    return args;
  }, {});

const args = getArgs();
const username = args.username;
const useremail = args.useremail;
const commitmsg = args.commitmsg;

console.log(username);
console.log(useremail);
console.log(commitmsg);

/*fetch(`https://api.github.com/user/${username}`, {
  "headers": {
    "User-Agent": "request",
    "Authorization": `Bearer ${token}`,
    "X-GitHub-Api-Version": "2022-11-28"
  }
}).then(res => {
  console.log(res);
});*/

console.log('test');

let base = "https://github.com/ReRand/ACE-ULTRA";

let tree = `${base}/tree/main/Logs`;
let blob = `${base}/blob/main/Logs`

let sep = (__dirname.includes("/")) ? "/" : "\\";

let basedir = __dirname.replace( ([ ".github", "workflows", "logs", "scripts"].join(sep)), "");
let dir = `${basedir}Logs`;
let logrefdir = `${basedir}logref.md`;

let groups = fs.readdirSync(dir);

let content = [

  "---",
  ""
  "# LogRef",
  "this is where log references are for easier navigation<br>",
  '<img height=22 src="https://github.com/ReRand/ACE-ULTRA/actions/workflows/logref.yml/badge.svg" alt="publish">',
  "",
  "---",
  ""
];


const config = require('./config.json');

const versionnames = config.versions;
const versions = {};


groups.forEach((group, gi) => {
  let groupdir = `${dir}/${group}`;
  let treelink = `${tree}/${ group.split(" ").join("%20") }`;
  let bloblink = `${blob}/${ group.split(" ").join("%20") }`;
  let logs = fs.readdirSync(groupdir);
  var vsubs = content;
  var v = content;
  
  versionnames.forEach((vn, i) => {
    let subref = group.split("_")[0];
    if (subref == vn) {
      if (!versions[vn]) versions[vn] = { header: `## ${vn}`, subs: [] };
      vsubs = versions[vn].subs;
    }
  });

  v = {
    header: `### [${group}](${treelink}) (group #${gi})`,
    content: []
  }

  vsubs.push(v);
  
  logs.forEach((log, li) => {
    let logbloblink = `${bloblink}/${ log.split(" ").join("%20") }`;
    let logdir = `${groupdir}/${ log }`;
    
    let filecontent = fs.readFileSync(logdir, 'utf8');
    let csplit = filecontent.split(/[\r\n]+/);

    var name;

    csplit.forEach(c => {
      if (c.match(/^# /)) {
        name = c.replace("# ", "").trim();
      }
    });

    if (!name) {
      name = log.replace(".md", "");
    };
    
    v.content.push(`${li+1}. ${name} [(${ log })](${ logbloblink }) `)
  });
});

versionnames.forEach((vn, i) => {
  if (versions[vn]) {
    let stuff = [];
    
    let ventry = versions[vn];
    let vsubs = ventry.subs;

    let start = [
      "",
      ventry.header
    ];

    start.forEach( s => stuff.push(s) );

    vsubs = vsubs.sort( (a, b) => {
      return a.header.localeCompare(b.header);
    });

    vsubs = (config.reverseSort) ? vsubs.reverse() : vsubs

    vsubs.forEach( (sub) => {
      let sheader = sub.header;
      let scontent = sub.content;

      scontent = (config.reverseSort) ? scontent.reverse() : scontent;
      
      stuff.push(sheader);
      scontent.forEach(c => stuff.push(c));
    });
    
    /*v = v.content.sort();
    v = (config.reverseSort) ? v.reverse() : v;*/

    let ends = [
      "",
      "---",
      ""
    ];

    ends.forEach( e => stuff.push(e) );
    
    content = content.concat(stuff);
  }
});

content = content.join("\n\n");


fs.writeFileSync(logrefdir, content);


console.log(fs.readFileSync(logrefdir, 'utf8'));
/*
const commands = [
  'echo os is running',  
  `git add ${logrefdir}`,
  `git commit -m "Refreshed logref.md" ${logrefdir}`,
  'git push',
  'git status'
];


if (username && useremail) {
    commands.splice(1, 0, `git config --global user.name ${username}`);
    commands.splice(1, 0, `git config --global user.email ${useremail}`);
}


console.log(commands);
    

commands.forEach( async c => {
  console.log(c);
  await exec(c);
})*/


const platform = os.platform();
const pytext = (platform.includes("win")) ? "py" : "python";

const pythonProcess = spawn(pytext, [ `${__dirname}/logref.py`, basedir, username, useremail, commitmsg, base ]);

pythonProcess.stdout.on('data', (data) => {
  console.log(data.toString());
});

pythonProcess.stderr.on('data', (data) => {
  let err = data.toString();
  
  console.log(`ERR!: ${err}`);
});
