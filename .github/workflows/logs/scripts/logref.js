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

let tree = `${base}/tree/main/logs`;
let blob = `${base}/blob/main/logs`

let sep = (__dirname.includes("/")) ? "/" : "\\";

let basedir = __dirname.replace( ([ ".github", "workflows", "logs", "scripts"].join(sep)), "");
let dir = `${basedir}Logs`;
let logrefdir = `${basedir}logref.md`;

let groups = fs.readdirSync(dir);

let content = [

  "# LogRef",
  "this is where log references are for easier navigation<br>",
  '<img height=22 src="https://github.com/ReRand/ACE-ULTRA/actions/workflows/logref.yml/badge.svg" alt="publish">'

];


const config = require('./config.json');
groups = groups.sort((a, b) => {
  return (config.reverseSort) ? b - a : a - b;
});


groups.forEach((group, gi) => {
  let groupdir = `${dir}/${group}`;
  let treelink = `${tree}/${ group.split(" ").join("%20") }`;
  let bloblink = `${blob}/${ group.split(" ").join("%20") }`;
  let logs = fs.readdirSync(groupdir);

  content.push(`### [${group}](${treelink}) (#${gi})`);
  
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
    
    content.push(`${li+1}. ${name} [(${ log })](${ logbloblink }) `)
  });
});


content = content.join("\n\n");

fs.writeFileSync(logrefdir, content)


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

const pythonProcess = spawn(pytext, [ `${__dirname}/logref.py`, username, useremail, commitmsg, base ]);

pythonProcess.stdout.on('data', (data) => {
  console.log(data.toString());
});

pythonProcess.stderr.on('data', (data) => {
  let err = data.toString();
  
  console.log(`ERR!: ${err}`);
});
