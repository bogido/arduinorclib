#ifndef INC_TX_EXPO_H
#define INC_TX_EXPO_H

/* ---------------------------------------------------------------------------
** This software is in the public domain, furnished "as is", without technical
** support, and with no warranty, express or implied, as to its usefulness for
** any purpose.
**
** Expo.h
** Exponential functionality
**
** Author: Daniel van den Ouden
** Project: ArduinoRCLib
** Website: http://sourceforge.net/p/arduinorclib/
** -------------------------------------------------------------------------*/

#include <inttypes.h>


namespace tx
{

/*! \brief Class to encapsulate Exponential functionality.*/
class Expo
{
public:
	/*! \brief Constructs an Expo object
	    \p_expo The expo to set, range [-100 - 100].*/
	Expo(int8_t p_expo = 0);

	/*! \brief Copy constructor
	    \p_rhs Object to copy with.*/
	Expo(const Expo& p_rhs);
	
	
	/*! \brief Sets the expo.
	    \p_expo The expo to set, range [-100 - 100].*/
	void set(int8_t p_expo);
	
	/*! \brief Gets expo.
	    \return The current expo, range [-100 - 100].*/
	int8_t get() const;
	
	/*! \brief Copy assignment operator.
	    \p_rhs Object to copy.
	    \return Reference to this object.*/
	Expo& operator = (const Expo& p_rhs);
	
	/*! \brief Assignment operator, sets expo.
	    \p_rhs The expo to set, range [-100 - 100].
	    \return Reference to this object.*/
	Expo& operator = (int8_t p_rhs);
	
	/*! \brief Cast operator, casts object to int8_t.
	    \return Current expo, range [-100 - 100].*/
	operator int8_t () const;
	
	/*! \brief Reference operator, allow direct access to member through pointer for flexible get/set.
	    \return Pointer to expo.*/
	int8_t* operator &();
	
	/*! \brief Reference operator, allow direct access to member through pointer for flexible get/set.
	    \return Pointer to expo.*/
	const int8_t* operator &() const;
	
	/*! \brief Applies expo.
	    \p_value Source value to apply expo to, range [-256 - 256].
		\p_expo Amount of expo to apply, range [-100 - 100].
		\return expo applies p_value.*/
	int16_t apply(int16_t p_value) const;
	
private:
	int8_t m_expo;
};


} // namespace end

#endif // INC_TX_EXPO_H
