module System.Generics.Collections;

import System.Classes: TObject;
import delta.core;

abstract class TEnumerable(T): TObject
{
	this(int reference)
	{
		super(reference);
	}
	
	mixin(GenIntProperty!("Count"));

}