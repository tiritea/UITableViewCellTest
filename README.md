# ios-uitableviewcelltest
Test various permutations of the built-in UITableViewCell styles when have *multi-line* text and detail, including using style-specific subclasses, style-specific reuse identifiers, numberOfLines=0 (vs n), and dequeuing-and-reusing cells vs re-allocing. Summary of observations:
<ul>
<li>None of the built-in UITableViewCell styles handle multi-line detailTextLabel; invariably the cell height calculated by UITableViewAutomaticDimension does not take into account the multiple lines of detail and the cell is too short, causing the content to spill over the top and bottom of the cell. UITableViewCellStyleDefault ignores detailTextLabel so it is unaffected. It appears the layout rules used by UITableViewAutomaticDimension account for a multi-line textLabel, but assume the detailTextLabel is always a single line.
<li>However, all the built-in UITableViewCell styles do appear to handle multiple lines of textLabel ok.
<li>numberOfLines=n, where n is the actual number of lines of text, does not consistently show all n lines of text (sic), whereas using numberOfLines=0 instead does.
<li>You must use style-specific subclasses, or style-specific reuseIdentifiers, when reusing different styles of cell in the same table. In particular, [cell initWithStyle:style reuseIdentifier:id] does *not* fully re-initialize the (reused) cell properly, so you may eventually get back a reused cell that is messed up; eg wrong colors for text and/or detail, wrong alignment, ...
<li>So long as you use style-specific reuseIdentifiers, it doesn't appear necessary to use style-specific subclasses. Note that without (custom) style-specific subclasses the [tableView dequeueReusableCellWithIdentifier:id] operation will automatically initialize any new cell it creates with the UITableViewCellStyleDefault style (!), even though you may immediately re-initialize the cell with your desired style. But, despite the previous comment, this unavoidable UITableViewCellStyleDefault pre-initialization doesn't appear to cause any problems when you re-style the cell.
</ul>
<br>Conclusion:
<ul>
<li>numberOfLines=n doesnt do what you expect; always use numberOfLines=0 to show multiple lines. This was unexpected.
<li>Always use style-specific subclasses or reuseIdentifiers, because [cell initWithStyle:style reuseIdentifier:id] wont fully re-init, or 'clean', a reused cell. This was unexpected.
<li>You can't use any of the built-in UITableViewCellStyles to reliably display multiple lines of *detail* - you'll have to create a UITableViewCell subclass instead. This is unfortunate, because it would make UITableViewCellStyleSubtitle a lot more useful.
</ul>

