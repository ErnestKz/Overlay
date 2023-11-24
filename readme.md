# Overlay Roadmap

- Overlay - Package Management 
  - Using this overlay for various personal repos.
  - Importing those repos into this overlay.
  - For personal repos, using central overlay to depend on other personal repos.
  - Pinning system with niv or flakes.
  - Bot on each private repo to update pin of the central overlay everytime there is a commit to the central overlay.
    - A commit that effects the output path of the derivations of the private repos!
     - Presumably a lot of the commits wont affect it.
     - possibility that can get stuck in a loop:
    - A depends on B
    - B depends on A
    - A is updated
    - TRIGGERED: B updates the overlay
    - TRIGGERED: A updates the overlay
   	  - but actually, it should trigger?
   	    - the only thing that gets updated is the pin?
   	      - something something
  - Then also CI pipeline for seeing if derivations build
  - Then separate repos for deployment declaration

- Overlay - Dev Swizzling
- Overlay - Machine Config Management
- Overlay - Deployment Management
- Overlay - CI Management
- Overlay - Test Management
- Overlay - Eco System Management
