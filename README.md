# autocommit
![Alt text](img/machine-gun.png?raw=true "Title")
<br>
This script automates the process of committing selected files within a Git repository.

# How to use
1. **Download the Script**: Go to your Git repository and download the script using the following command:
```
curl -O https://raw.githubusercontent.com/aburayyanjeffry/autocommit/main/autocommit.sh
```

2. **Make the Script Executable**: After downloading the script, make it executable with the following command:
```
chmod +x autocommit.sh
```

3. **Specify Files to Auto Commit**: Create a file named `.gitautocommit` within your repository. In this file, list the files you want to auto-commit, one per line.

4. **Testing the Script**: To test the script, make any changes to the files specified in the .gitautocommit file. Then, execute the script using the following command:
```
./autocommit.sh
```

5. **Automate with Cron**: If you want the script to run automatically at regular intervals, you can add it to your crontab. Below is an example of a crontab entry that runs the script every hour:
```
0 * * * * /path-to-your-repo/autocommit.sh
```

**Note**: Be cautious when automating Git commits, especially in a production environment, as it can affect your repository's history.
