# ❌ NE PAS FAIRE (suppression simple ne suffit pas)
   $ git rm alpha.crt
   $ git commit -m "Remove sensitive file"
   $ git push
   # La clé reste dans l'historique Git!
   
   # ✅ BONNE MÉTHODE - Purger l'historique Git
   $ git filter-branch --force --index-filter \
     "git rm --cached --ignore-unmatch alpha.crt" \
     --prune-empty --tag-name-filter cat -- --all
   
   # Forcer le push (réécrit l'historique)
   $ git push origin --force --all
   $ git push origin --force --tags
   
   # Alternative avec BFG Repo-Cleaner (plus rapide)
   $ brew install bfg
   $ bfg --delete-files alpha.crt
   $ git reflog expire --expire=now --all
   $ git gc --prune=now --aggressive
   $ git push origin --force --all
