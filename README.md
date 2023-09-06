# autocommit
![Alt text](img/machine-gun.png?raw=true "Title")
<br>
A script to auto commit  some selected files at a git repository

# How to use
- Go to your git repository download
```
curl -O https://raw.githubusercontent.com/aburayyanjeffry/autocommit/main/autocommit.sh
```

- Make the script executable
```
chmod +x autocommit.sh
```

- Put the files to be auto commit in th e `.autocommit` file

- To test the script, do any change to any of the files that specified in the `.autocommit` file. Then execute the script
```
./autocommit.sh
```

- Put this script at crontab to make it run automatically. The following is the sample of a crontab that runs every hour
```
0 * * * * /path-to-your-repo/autocommit.sh
```
