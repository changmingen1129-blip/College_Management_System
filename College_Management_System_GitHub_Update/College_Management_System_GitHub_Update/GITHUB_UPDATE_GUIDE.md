# GitHub Update Guide

This guide explains how to add the database scripts and improved README to the existing College Management System repository.

## Recommended Method: Upload Through a New Branch

1. Sign in to GitHub and open the repository.
2. Click the current branch selector, which currently shows `master`.
3. Type `database-documentation`.
4. Choose **Create branch: database-documentation from master**.
5. Open the new branch.
6. Click **Add file > Upload files**.
7. Upload the complete `Database` folder from this package.
8. Add a commit message:

```text
Add complete SQL Server database scripts
```

9. Commit the files to the `database-documentation` branch.
10. Open the existing `README.md` file.
11. Click the pencil icon to edit it.
12. Replace the old content with the new `README.md` supplied in this package.
13. Use the commit message:

```text
Update README with setup and test instructions
```

14. Open the **Pull requests** tab.
15. Click **New pull request**.
16. Set:

```text
base: master
compare: database-documentation
```

17. Use the pull request title:

```text
Add database scripts and project setup documentation
```

18. Review the changed files and create the pull request.
19. After checking the files, click **Merge pull request** and confirm the merge.
20. Capture screenshots of the branch, pull request and merged result for the portfolio.

## Alternative Method: Git Command Line

Copy the `Database` folder and the new `README.md` into the local repository, then run:

```bash
git checkout -b database-documentation
git add Database README.md
git commit -m "Add database scripts and setup documentation"
git push -u origin database-documentation
```

Then open GitHub and create a pull request from `database-documentation` into `master`.

## Final Checks

- Confirm the `Database` folder is visible in the repository root.
- Open each SQL file on GitHub to make sure it is readable.
- Confirm the README displays headings, tables and code blocks correctly.
- Keep the repository public until grading is complete.
- Do not upload real passwords, private tokens or confidential data.
