# Figures Directory

Place your thesis figures and images in this directory.

## Organization

You can organize your figures by chapter:

```
Figures/
 Chapter1/
    figure1.png
 Chapter2/
    figure2.png
 ...
```

Or keep them all in the root Figures directory:

```
Figures/
 figure1.png
 figure2.png
 ...
```

## Supported Formats

- PNG (recommended for screenshots and plots)
- PDF (recommended for vector graphics)
- JPG/JPEG
- SVG (will be converted to PDF)

## Using Figures in Your Thesis

Reference figures in your chapters using:

```markdown
![Caption for your figure](../Figures/your-figure.png){#fig-label}

As shown in @fig-label, we can observe...
```
