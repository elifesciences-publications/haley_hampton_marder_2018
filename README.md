# haley_2018
> Analysis package for the paper Haley, Hampton, and Marder (2018)

These codes can be adapted to analyze intracellular waveforms and extracellular nerve recordings from bursting neurons. Custom violin and stacked bar graph plotting scripts are included.

## Software

I used the following software for analyses:
- pClamp 10.5
- Spike2 v6.04
- MATLAB 2018a
- R v3.5.0
- RStudio 1.1.456

## File List

- `abfload.m` : reads a .abf file (produced in pClamp) and produces a basic MATLAB structure
- `Loadabf.m` : wrapper for `abfload.m`; produces a more organized MATLAB struture for reading .abf files
- `convertpH.m`




#### Argument 1
Type: `String`  
Default: `'default value'`

State what an argument does and how you can use it. If needed, you can provide
an example below.

Example:
```bash
awesome-project "Some other value"  # Prints "You're nailing this readme!"
```

#### Argument 2
Type: `Number|Boolean`  
Default: 100

Copy-paste as many of these as you need.


## Links

- Project homepage: https://your.github.com/awesome-project/
- Repository: https://github.com/your/awesome-project/
- Issue tracker: https://github.com/your/awesome-project/issues
  - In case of sensitive bugs like security vulnerabilities, please contact
    my@email.com directly instead of using issue tracker. We value your effort
    to improve the security and privacy of this project!
- Related projects:
  - Your other project: https://github.com/your/other-project/
  - Someone else's project: https://github.com/someones/awesome-project/


## Licensing

One really important part: Give your project a proper license. Here you should
state what the license is and how to find the text version of the license.
Something like:

"The code in this project is licensed under MIT license."
