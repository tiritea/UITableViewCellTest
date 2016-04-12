# ios-uitableviewcelltest
Test various permutations of the built-in UITableViewCell styles when &lt;BR>have *multi-line* text and detail, including using style-specific subclasses, style-specific reuse identifiers, numberOfLines=0 (vs n), and dequeuing-and-reusing cells vs re-allocing.
<br>Summary
<ul>
<li>none of the built-in UITableViewCell styles handle multi-line detailText; invariably the cell height calculated by UITableViewAutomaticDimension doesnt take into aacount the multiple lines of detailText and the cell of too short, causing the content to spill over the top and bottom.
<li>all the built-in UITableViewCell styles do appear to handle multi-line text ok, however.
<li>numberOfLines=n, where n is the actual number of lines of text, does not consistently show n lines of text (sic), whereas using numberOfLines=0 instead does.
<li>you must use style-specific subclasses, or at least style-specific reuseIdentifiers, when reusing different styles of cell in the same table. In particular, [cell initWithStyle:style reuseIdentifier:id] does *not* re-initialize the (reused) cell properly, so it can be formatted wrong (eg wrong colors, wrong alaignment, ...). 
</ul>
